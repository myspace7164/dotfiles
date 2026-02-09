{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/gnome
    ../../modules/plymouth
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  networking.hostName = "player";

  environment.systemPackages = with pkgs; [
    gitwatch
  ];
}
