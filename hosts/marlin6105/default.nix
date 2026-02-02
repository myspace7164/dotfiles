{ pkgs, ... }:

let
  dataDir = "/mnt/drive/syncthing";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/syncthing
    ../../modules/users
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "marlin6105";
  networking.networkmanager.enable = true;

  fileSystems."/mnt/drive" = {
    device = "/dev/disk/by-uuid/6fa81b71-8a9a-4de8-ab8f-c93f7a4e18ad";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wireguard-tools
  ];

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings.PasswordAuthentication = false;
  };

  services.syncthing = {
    dataDir = dataDir;

    settings.folders."~/archive".path = "${dataDir}/archive";
    settings.folders."~/audio".path = "${dataDir}/audio";
    settings.folders."~/backup".path = "${dataDir}/backup";
    settings.folders."~/documents".path = "${dataDir}/documents";
    settings.folders."~/games".path = "${dataDir}/games";
    settings.folders."~/hosts".path = "${dataDir}/hosts";
    settings.folders."~/inbox".path = "${dataDir}/inbox";
    settings.folders."~/music".path = "${dataDir}/music";
    settings.folders."~/notes".path = "${dataDir}/notes";
    settings.folders."~/org".path = "${dataDir}/org";
    settings.folders."~/pictures".path = "${dataDir}/pictures";
    settings.folders."~/projects".path = "${dataDir}/projects";
    settings.folders."~/recovery".path = "${dataDir}/recovery";
    settings.folders."~/templates".path = "${dataDir}/templates";
    settings.folders."~/video".path = "${dataDir}/video";

    settings.folders."SeedVaultAndroidBackup" = {
      id = "ojr5r-owslz";
      path = "${dataDir}/SeedVaultAndroidBackup";
      devices = [
        "device"
        "marlin6105"
      ];
    };
  };

  services.paperless = {
    enable = true;
    address = "0.0.0.0";
    user = "user";
    dataDir = "/mnt/drive/paperless";
  };
  networking.firewall.allowedTCPPorts = [ 28981 ];

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.11";
}
