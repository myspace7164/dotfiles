{ pkgs, ... }:

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
    dataDir = "/mnt/drive/syncthing";
    settings.folders."~/games".path = "/mnt/drive/syncthing/games";
    settings.folders."~/org".path = "/mnt/drive/syncthing/org";
    settings.folder."SeedVaultAndroidBackup".path = "/mnt/drive/syncthing/SeedVaultAndroidBackup";
  };

  services.paperless = {
    enable = true;
    address = "0.0.0.0";
    user = "user";
    dataDir = "/mnt/drive/paperless";
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.11";
}
