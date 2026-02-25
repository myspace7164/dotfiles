{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/syncthing
    ../../modules/users
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.grub.enable = false;
  boot.loader.timeout = 0;
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/media" = {
    device = "192.168.1.135:/volume1/media";
    fsType = "nfs";
  };

  nixpkgs.overlays = [
    inputs.self.overlays.unstable-packages
  ];

  networking.hostName = "marlin";
  networking.networkmanager.enable = true;

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
        flags = {
          chmod_f = "644";
          chmod_d = "755";
        };
      };
    };
  };

  services.grocy = {
    enable = false;
  };

  services.jellyfin = {
    enable = true;
    dataDir = "/mnt/drive/jellyfin";
    openFirewall = true;
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
          "marlin"
        ];
      };
    };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    package = pkgs.unstable.tailscale;
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
      ExecStart = "${pkgs.coreutils-full}/bin/nice -n 19 ${pkgs.util-linux}/bin/ionice -c3 ${pkgs.unstable.rclone}/bin/rclone sync -v /mnt/drive backup: --transfers 1 --checkers 2 --bwlimit 2M --buffer-size 4m";
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

  systemd.services.gitwatch-org = {
    enable = true;
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "gitwatch for org";
    path = with pkgs; [
      gitwatch
      git
    ];
    script = "gitwatch /mnt/drive/syncthing/org";
    serviceConfig.User = "syncthing";
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.11";

  system.autoUpgrade = {
    allowReboot = true;
    dates = "01:40";
    enable = true;
    flags = [ "-L" ];
    flake = inputs.self.outPath;
    runGarbageCollection = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 400;
  };

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
  ];
}
