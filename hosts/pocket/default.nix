{ config, pkgs, ... }:

{
  imports = [
    ../configuration.nix
    ../../modules/boot
    ../modules/sway.nix
    ../modules/virtualisation.nix
  ];

  networking.hostName = "pocket";
}
