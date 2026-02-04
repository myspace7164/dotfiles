{ pkgs, ... }:

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

  networking.hostName = "marlin6105";
  networking.networkmanager.enable = true;
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

  fileSystems."/mnt/drive" = {
    device = "/dev/disk/by-uuid/6fa81b71-8a9a-4de8-ab8f-c93f7a4e18ad";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  environment.systemPackages = with pkgs; [
    copyparty
    git
    vim
    wireguard-tools
  ];

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

      settings.folders."dig4718".path = "${dataDir}/dig4718";
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

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.11";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.flake = "github:myspace7164/dotfiles";

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  services.copyparty = {
    enable = true;
    user = "copyparty";
    group = "copyparty";

    settings = {
      i = "0.0.0.0";
      daw = true;
    };

    accounts.mousy6863.passwordFile = "/root/copyparty/password";
    groups.group = [ "mousy6863" ];

    volumes = {
      "/" = {
        path = "/mnt/drive/copyparty";
        access.rwd = [ "mousy6863" ];
      };
    };
  };
}
