{ ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.11";

  home.file = {
    ".bashrc".source = ../../config/bash/.bashrc;
    ".bash_profile".source = ../../config/bash/.bash_profile;
    ".local/bin".source = ../../bin;
    ".local/share/scripts".source = ../../scripts;
  };

  xdg.configFile = {
    "beets/config.yaml".source = ../../config/beets/config.yaml;
    "emacs/init.el".source = ../../config/emacs/init.el;
    "emacs/early-init.el".source = ../../config/emacs/early-init.el;
    "ghostty/config".source = ../../config/ghostty/config;
    "ghostty/themes".source = ../../config/ghostty/themes;
    "git/config".source = ../../config/git/config;
    "i3status/config".source = ../../config/i3status/config;
    "kanshi/config".source = ../../config/kanshi/config;
    "mako/config".source = ../../config/mako/config;
    "nix/nix.conf".source = ../../config/nix/nix.conf;
    "sway/config".source = ../../config/sway/config;
    "tmux/tmux.conf".source = ../../config/tmux/tmux.conf;
    "yazi".source = ../../config/yazi;
  };

  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

  # unison
  xdg.configFile."systemd/user/unison-drive.service".source =
    ../../config/unison/unison-drive.service;
  xdg.configFile."systemd/user/unison-usb.service".source = ../../config/unison/unison-usb.service;

  home.file = {
    ".unison/backup-drive.prf".source = ../../config/unison/backup-drive.prf;
    ".unison/backup-usb.prf".source = ../../config/unison/backup-usb.prf;
  };

  #  home.activation.daemonReload = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #  ${pkgs.systemd}/bin/systemctl --user daemon-reload
  #  ${pkgs.systemd}/bin/systemctl --user start unison-drive.service
  #  ${pkgs.systemd}/bin/systemctl --user enable unison-drive.service
  #  ${pkgs.systemd}/bin/systemctl --user start unison-usb.service
  #  ${pkgs.systemd}/bin/systemctl --user enable unison-usb.service
  #'';

  programs.man.generateCaches = true;
}
