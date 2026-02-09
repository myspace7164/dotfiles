{ config, ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.11";

  home.file = {
    ".bash_profile".source = ../../config/bash/.bash_profile;
    ".bashrc".source = ../../config/bash/.bashrc;
    ".local/bin".source = ../../bin;
    ".local/share/scripts".source = ../../scripts;
    ".mbsyncrc".source = ../../config/mail/.mbsyncrc;
    ".msmtprc".source = ../../config/mail/.msmtprc;
  };

  xdg.configFile = {
    "beets/config.yaml".source = ../../config/beets/config.yaml;
    "foot/foot.ini".source = ../../config/foot/foot.ini;
    "git/config".source = ../../config/git/config;
    "i3status/config".source = ../../config/i3status/config;
    "kanshi/config".source = ../../config/kanshi/config;
    "mako/config".source = ../../config/mako/config;
    "nix/nix.conf".source = ../../config/nix/nix.conf;
    "sway/config".source = ../../config/sway/config;
    "tmux/tmux.conf".source = ../../config/tmux/tmux.conf;
    "yazi".source = ../../config/yazi;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/.user-dirs.dirs/Desktop";
    documents = "${config.home.homeDirectory}/.user-dirs.dirs/Documents";
    download = "${config.home.homeDirectory}/tmp";
    music = "${config.home.homeDirectory}/.user-dirs.dirs/Music";
    pictures = "${config.home.homeDirectory}/.user-dirs.dirs/Pictures";
    publicShare = "${config.home.homeDirectory}/.user-dirs.dirs/Public";
    templates = "${config.home.homeDirectory}/.user-dirs.dirs/Templates";
    videos = "${config.home.homeDirectory}/.user-dirs.dirs/Videos";
  };

  # emacs
  home.file = {
    ".emacs.d/early-init.el".source = ../../config/emacs/early-init.el;
    ".emacs.d/init.el".source = ../../config/emacs/init.el;
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

  programs.man.generateCaches = true;
}
