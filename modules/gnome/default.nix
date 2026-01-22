{ pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # disable GNOME's suite of applications
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/shell" = {
            favorite-apps = [
              "librewolf.desktop"
              "org.gnome.Nautilus.desktop"
              "emacs.desktop"
              "com.stremio.Stremio.desktop"
              "steam.desktop"
              "ente-desktop.desktop"
            ];
            enabled-extensions = [
              "status-area-horizontal-spacing@mathematical.coffee.gmail.com"
              "appindicatorsupport@rgcjonas.gmail.com"
              "gsconnect@andyholmes.github.io"
              "BingWallpaper@ineffable-gmail.com"
            ];
          };
          "org/gnome/shell/extensions/bingwallpaper" = {
            hide = true;
          };
          "org/gnome/shell/extensions/status-area-horizontal-spacing" = {
            hpadding = "4";
          };
        };
      }
    ];

  };

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # GNOME specific packages
  environment.systemPackages = with pkgs; [
    dconf-editor
    gnome-console
    gnome-themes-extra
    gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.bing-wallpaper-changer
    gnomeExtensions.status-area-horizontal-spacing
    nautilus
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # remove xterm
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.excludePackages = [ pkgs.xterm ];
}
