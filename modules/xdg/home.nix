{ config, lib, pkgs, ... }:
{
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
}
