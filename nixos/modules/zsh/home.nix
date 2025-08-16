{ config, pkgs, ... }:

{
  home.file.".zprofile".source = ./.zprofile;
  home.file.".zshenv".source = ./.zshenv;
  home.file.".zshrc".source = ./.zshrc;
}
