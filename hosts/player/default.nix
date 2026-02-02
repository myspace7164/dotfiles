{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot
    ../../modules/desktop
    ../../modules/gnome
    ../../modules/plymouth
  ];

  networking.hostName = "player";

  environment.systemPackages = with pkgs; [
    gitwatch
  ];
}
