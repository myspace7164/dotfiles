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

  # Enable the Plasma 6 (KDE 6) Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    hardinfo2
    haruna
    kdePackages.discover
    kdePackages.isoimagewriter
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kcolorchooser
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.partitionmanager
    kdePackages.sddm-kcm
    kdiff3
    wayland-utils
    wl-clipboard
  ];

  hardware.bluetooth.enable = true;

  qt = {
    enable = true;
    platformTheme = "kde6";
    style = "breeze";
  };
}
