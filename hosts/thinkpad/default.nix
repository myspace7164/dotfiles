{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/hack-the-box.nix
    ../../modules/sway
    ../../modules/virtualisation
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  networking.hostName = "thinkpad";

  environment.systemPackages = [ pkgs.rclone ];

  services.tlp.enable = true;
  services.davfs2.enable = true;
}
