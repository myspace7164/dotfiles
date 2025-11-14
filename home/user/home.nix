{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.05";

  home.file = {
    ".local/bin".source = ../../bin;
    ".local/share/scripts".source = ../../scripts;
    # zsh
    ".zprofile".source = ../../config/zsh/.zprofile;
    ".zshenv".source = ../../config/zsh/.zshenv;
    ".zshrc".source = ../../config/zsh/.zshrc;
  };

  xdg.configFile = {
    "beets/config.yaml".source = ../../config/beets/config.yaml;
    "ghostty/config".source = ../../config/ghostty/config;
    "ghostty/themes".source = ../../config/ghostty/themes;
    "git/config".source = ../../config/git/config;
    "i3status/config".source = ../../config/i3status/config;
    "kanshi/config".source = ../../config/kanshi/config;
    "mako/config".source = ../../config/mako/config;
    "sway/config".source = ../../config/sway/config;
    "tmux/tmux.conf".source = ../../config/tmux/tmux.conf;
  };

  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

  # emacs
  home.file = {
    ".emacs.d/init.el".source = ../../config/emacs/init.el;
    ".emacs.d/early-init.el".source = ../../config/emacs/early-init.el;
  };

  xdg.desktopEntries = {
    org-protocol = {
      name = "org-protocol";
      comment = "Intercept calls from emacsclient to trigger custom actions";
      icon = "emacs";
      type = "Application";
      exec = "emacsclient -- %u";
      terminal = false;
      mimeType = [ "x-scheme-handler/org-protocol" ];
    };
  };

  # neovim
  programs.neovim = {
    enable = true;
    extraLuaConfig = lib.fileContents ../../config/nvim/init.lua;
    plugins = with pkgs.vimPlugins; [
      modus-themes-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      telescope-nvim
    ];
    extraPackages = [ pkgs.tree-sitter ];
  };

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

  # steam
  xdg.desktopEntries.steam-pipewire = {
    name = "Steam (PipeWire)";
    exec = "steam -pipewire";
    icon = "steam";
    comment = "Launch Steam with PipeWire support";
    categories = [ "Game" ];
  };

  programs.man.generateCaches = true;
}
