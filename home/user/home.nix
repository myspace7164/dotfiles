{ config, lib, pkgs, ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.05";

  home.file = {
    ".local/bin".source = ../../bin;
    ".local/share/scripts".source = ../../scripts;
    ".local/share/themes".source = ../../themes;
    # zsh
    ".zprofile".source = ../../config/zsh/.zprofile;
    ".zshenv".source = ../../config/zsh/.zshenv;
    ".zshrc".source = ../../config/zsh/.zshrc;
  };

  xdg.configFile = {
    "beets/config.yaml".source = ../../config/beets/config.yaml;
    "ghostty/config".source = ../../config/ghostty/config;
    "ghostty/themes/modus-vivendi".source = ../../config/ghostty/themes/modus-vivendi;
    "ghostty/themes/modus-operandi".source = ../../config/ghostty/themes/modus-operandi;
    "git/config".source = ../../config/git/config;
    "i3status/config".source = ../../config/i3status/config;
    "kanshi/config".source = ../../config/kanshi/config;
    "mako/config".source = ../../config/mako/config;
    "sway/config".source = ../../config/sway/config;
    "tmux/tmux.conf".source = ../../config/tmux/tmux.conf;
  };

  xdg.userDirs = {
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/.user-dirs.dirs/Desktop";
    download = "${config.home.homeDirectory}/tmp";
    templates = "${config.home.homeDirectory}/.user-dirs.dirs/Templates";
    publicShare = "${config.home.homeDirectory}/.user-dirs.dirs/Public";
    documents = "${config.home.homeDirectory}/.user-dirs.dirs/Documents";
    music = "${config.home.homeDirectory}/.user-dirs.dirs/Music";
    pictures = "${config.home.homeDirectory}/.user-dirs.dirs/Pictures";
    videos = "${config.home.homeDirectory}/.user-dirs.dirs/Videos";
  };

  # emacs
  home.file = {
    ".emacs.d/init.el".source = ../../config/emacs/init.el;
    ".emacs.d/early-init.el".source = ../../config/emacs/early-init.el;
  };

  xdg.dataFile."applications/org-protocol.desktop".source = ../../config/emacs/org-protocol.desktop;

  home.activation.updateDesktopDatabase = lib.hm.dag.entryAfter ["writeBoundary"] ''
  ${pkgs.desktop-file-utils}/bin/update-desktop-database ~/.local/share/applications
'';

  # neovim
  programs.neovim.enable = true;
  programs.neovim.extraLuaConfig = lib.fileContents ../../config/nvim/init.lua;
  programs.neovim.plugins = with pkgs.vimPlugins; [
		modus-themes-nvim
  ];

  # unison
  xdg.configFile."systemd/user/unison-drive.service".source = ../../config/unison/unison-drive.service;
  xdg.configFile."systemd/user/unison-usb.service".source = ../../config/unison/unison-usb.service;

  home.file = {    
    ".unison/backup-drive.prf".source = ../../config/unison/backup-drive.prf;
    ".unison/backup-usb.prf".source = ../../config/unison/backup-usb.prf;
  };

  home.activation.daemonReload = lib.hm.dag.entryAfter ["writeBoundary"] ''
  ${pkgs.systemd}/bin/systemctl --user daemon-reload
  ${pkgs.systemd}/bin/systemctl --user start unison-drive.service
  ${pkgs.systemd}/bin/systemctl --user enable unison-drive.service
  ${pkgs.systemd}/bin/systemctl --user start unison-usb.service
  ${pkgs.systemd}/bin/systemctl --user enable unison-usb.service
'';

  # mail
  home.file.".mbsyncrc".source = ../../config/mail/.mbsyncrc;
  home.file.".msmtprc".source = ../../config/mail/.msmtprc;

  programs.man.generateCaches = true;
}
