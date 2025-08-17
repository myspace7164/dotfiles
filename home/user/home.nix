{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/emacs/home.nix
    ../../modules/zsh/home.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.05";

  home.file = {
    # .config
    ".config/beets/config.yaml".source = ../../modules/beets/config.yaml;
    ".config/git/config".source = ../../modules/git/config;
    ".config/i3status/config".source = ../../modules/i3status/config;
    ".config/kanshi/config".source = ../../modules/kanshi/config;
    ".config/mako/config".source = ../../modules/mako/config;
    ".config/nvim/init.lua".source = ../../modules/nvim/init.lua;
    ".config/sway/config".source = ../../modules/sway/config;
    ".config/tmux/tmux.conf".source = ../../modules/tmux/tmux.conf;
    ".config/wezterm/wezterm.lua".source = ../../modules/wezterm/wezterm.lua;

    # .local/bin
    ".local/bin".source = ../../bin;

    # mail
    ".mbsyncrc".source = ../../modules/mail/.mbsyncrc;
    ".msmtprc".source = ../../modules/mail/.msmtprc;

    # unison
    ".config/systemd/user/unison-drive.service".source = ../../modules/unison/unison-drive.service;
    ".config/systemd/user/unison-usb.service".source = ../../modules/unison/unison-usb.service;
    ".unison/backup-drive.prf".source = ../../modules/unison/backup-drive.prf;
    ".unison/backup-usb.prf".source = ../../modules/unison/backup-usb.prf;
  };

  home.activation.daemonReload = lib.hm.dag.entryAfter ["writeBoundary"] ''
  ${pkgs.systemd}/bin/systemctl --user daemon-reload
'';

}
