{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../..
    ../../modules/emacs
    ../../modules/librewolf
    ../../modules/sway
    ../../modules/virtualisation
    ../../modules/zsh
    ../../modules/hack-the-box.nix
  ];

  networking.hostName = "thinkpad";

  time.timeZone = "Europe/Zurich";
}
