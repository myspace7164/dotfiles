{ pkgs, ... }:

let
  syncthingDataDir = "/mnt/drive/syncthing";
in
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
    dataDir = syncthingDataDir;

    settings.folders."~/archive".path = "${syncthingDataDir}/archive";
    settings.folders."~/backup".path = "${syncthingDataDir}/backup";
    settings.folders."~/documents".path = "${syncthingDataDir}/documents";
    settings.folders."~/games".path = "${syncthingDataDir}/games";
    settings.folders."~/music".path = "${syncthingDataDir}/music";
    settings.folders."~/org".path = "${syncthingDataDir}/org";
    settings.folders."~/projects".path = "${syncthingDataDir}/projects";

    settings.folders."SeedVaultAndroidBackup" = {
      id = "ojr5r-owslz";
      path = "${syncthingDataDir}/SeedVaultAndroidBackup";
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
