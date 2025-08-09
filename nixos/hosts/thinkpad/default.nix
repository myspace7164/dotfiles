{ config, pkgs, ... }:

{
  imports = [
    ../..
    ../../modules/hack-the-box.nix
    ../../modules/sway.nix
    ../../modules/virtualisation.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "thinkpad";

  time.timeZone = "Europe/Helsinki";
}
