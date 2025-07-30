{ config, pkgs, ... }:

{
  imports = [
    ../../configuration.nix
    ../../modules/hack-the-box.nix
    ../../modules/plasma.nix
    ../../modules/plymouth.nix
    ../../modules/virtualisation.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "thinkpad";

  services.xserver.xkb.layout = "ch";
}
