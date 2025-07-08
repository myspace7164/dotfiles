{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
    variant = "";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  programs.dconf.enable = true;
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
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
