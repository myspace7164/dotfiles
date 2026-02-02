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
    settings.folders."~/audio".path = "${syncthingDataDir}/audio";
    settings.folders."~/backup".path = "${syncthingDataDir}/backup";
    settings.folders."~/documents".path = "${syncthingDataDir}/documents";
    settings.folders."~/games".path = "${syncthingDataDir}/games";
    settings.folders."~/hosts".path = "${syncthingDataDir}/hosts";
    settings.folders."~/inbox".path = "${syncthingDataDir}/inbox";
    settings.folders."~/music".path = "${syncthingDataDir}/music";
    settings.folders."~/notes".path = "${syncthingDataDir}/notes";
    settings.folders."~/org".path = "${syncthingDataDir}/org";
    settings.folders."~/pictures".path = "${syncthingDataDir}/pictures";
    settings.folders."~/projects".path = "${syncthingDataDir}/projects";
    settings.folders."~/recovery".path = "${syncthingDataDir}/recovery";
    settings.folders."~/templates".path = "${syncthingDataDir}/templates";
    settings.folders."~/video".path = "${syncthingDataDir}/video";

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
