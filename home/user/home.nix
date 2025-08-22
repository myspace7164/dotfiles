{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/emacs/home.nix
    ../../modules/unison/home.nix
    ../../modules/xdg/home.nix
    ../../modules/zsh/home.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.05";

  xdg.configFile = {
    "beets/config.yaml".source = ../../modules/beets/config.yaml;
    "git/config".source = ../../modules/git/config;
    "i3status/config".source = ../../modules/i3status/config;
    "kanshi/config".source = ../../modules/kanshi/config;
    "mako/config".source = ../../modules/mako/config;
    "nvim/init.lua".source = ../../modules/nvim/init.lua;
    "sway/config".source = ../../modules/sway/config;
    "tmux/tmux.conf".source = ../../modules/tmux/tmux.conf;
    "wezterm/wezterm.lua".source = ../../modules/wezterm/wezterm.lua;
  };

  # mail
  home.file.".mbsyncrc".source = ../../modules/mail/.mbsyncrc;
  home.file.".msmtprc".source = ../../modules/mail/.msmtprc;
}
