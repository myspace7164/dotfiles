{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./sway.nix
    ./virtualisation.nix
  ];

  networking.hostName = "thinkpad";
}
