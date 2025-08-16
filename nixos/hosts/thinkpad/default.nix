{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../..
    ../../modules/emacs
    ../../modules/sway
    ../../modules/virtualisation
    ../../modules/hack-the-box.nix
  ];

  networking.hostName = "thinkpad";

  time.timeZone = "Europe/Helsinki";
}
