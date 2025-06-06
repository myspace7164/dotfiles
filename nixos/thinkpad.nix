{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./sway.nix
    ./virtualisation.nix
    ./packages.nix
  ];

  networking.hostName = "thinkpad";
}
