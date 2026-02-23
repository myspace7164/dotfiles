{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/hack-the-box.nix
    ../../modules/marlin6105-dav
    ../../modules/sway
    ../../modules/virtualisation
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/media" = {
    device = "192.168.1.135:/volume1/media";
    fsType = "nfs";
  };

  networking.hostName = "thinkpad";

  services.tailscale.enable = true;
  services.tlp.enable = true;
}
