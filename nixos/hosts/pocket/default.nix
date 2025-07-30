{ config, pkgs, ... }:

{
  imports = [
    ../configuration.nix
    ../modules/sway.nix
    ../modules/virtualisation.nix
  ];

  networking.hostName = "pocket";
}
