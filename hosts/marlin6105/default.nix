{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/syncthing
    ../../modules/users
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
  boot.loader.timeout = 0;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  nixpkgs.overlays = [
    inputs.self.overlays.unstable-packages
  ];

  networking.hostName = "marlin6105";
  networking.networkmanager.enable = true;

  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/root/wireguard-keys/private";

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      peers = [
        {
          publicKey = "6q/O7CwFllVhaTF3B9KBrmVMlcO9MdFYXgU/1K9x7Q8=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          publicKey = "WKJRz8KnCo+xdi3AfWzcMcV6oZLxde8qj5SQUjsQbRs=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };

  fileSystems."/mnt/drive" = {
    device = "/dev/disk/by-uuid/6fa81b71-8a9a-4de8-ab8f-c93f7a4e18ad";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  environment.systemPackages = with pkgs; [
    copyparty
    git
    gitwatch
    unstable.rclone
    vim
    wireguard-tools
  ];

  services.copyparty = {
    enable = true;
    user = "copyparty";
    group = "copyparty";

    settings = {
      i = "0.0.0.0";
      daw = true;
      acao = "moz-extension://797c70b0-c04f-445c-b70b-be1246ad52ac";
    };

    accounts.mousy6863.passwordFile = "/root/copyparty/password";
    groups.group = [ "mousy6863" ];

    volumes = {
      "/" = {
        path = "/mnt/drive/copyparty";
        access.rwmd = [ "mousy6863" ];
      };
    };
  };

  services.grocy = {
    enable = false;
  };

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings.PasswordAuthentication = false;
  };

  services.paperless = {
    enable = true;
    address = "0.0.0.0";
    user = "paperless";
    dataDir = "/mnt/drive/paperless";
    settings = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_CONVERT_MEMORY_LIMIT = 32;
      PAPERLESS_CONVERT_TMPDIR = "/mnt/drive/paperless/tmp";
    };
  };

  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [
          "0.0.0.0:5232"
        ];
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/mnt/drive/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        filesystem_folder = "/mnt/drive/radicale/collections";
      };
    };
  };

  services.syncthing =
    let
      dataDir = "/mnt/drive/syncthing";
    in
    {
      user = "syncthing";
      group = "syncthing";
      dataDir = dataDir;
      guiAddress = "0.0.0.0:8384";

      settings.folders."~/notes".path = "${dataDir}/notes";
      settings.folders."~/org".path = "${dataDir}/org";
      settings.folders."SeedVaultAndroidBackup" = {
        id = "ojr5r-owslz";
        path = "${dataDir}/SeedVaultAndroidBackup";
        devices = [
          "device"
          "marlin6105"
        ];
      };
    };

  systemd.timers.rclone-sync = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "rclone-sync.service";
    };
  };

  systemd.services.rclone-sync = {
    serviceConfig = {
      ExecStart = "${pkgs.unstable.rclone}/bin/rclone sync -v /mnt/drive backup:";
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.services.gitwatch-notes = {
    enable = true;
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "gitwatch for notes";
    path = with pkgs; [
      gitwatch
      git
    ];
    script = "gitwatch /mnt/drive/syncthing/notes";
    serviceConfig.User = "syncthing";
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.11";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.flake = "github:myspace7164/dotfiles";

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    # copyparty
    80
    443
    3921
    3922
    3923
    3945
    3990
    # paperless
    28981
    # radicale
    5232
    # syncthing
    8384
  ];
  # the below are copyparty
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 12000;
      to = 12099;
    }
  ];
  networking.firewall.allowedUDPPorts = [
    69
    1900
    3969
    5353
    # wireguard
    51820
  ];
}
