{ config, pkgs, ... }:
{
  imports = [
    ../../modules/emacs/home.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.05";
}
