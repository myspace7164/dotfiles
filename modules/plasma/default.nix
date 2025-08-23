{ config, lib, pkgs, ... }:

let
  background-package = pkgs.runCommand "background-image" {} ''
  cp ${./10-3-6k.jpg} $out
'';
in
{
  boot.plymouth.theme = "breeze";
  
  # Enable the Plasma 6 (KDE 6) Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = lib.mkDefault true;
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
    kdePackages.kleopatra
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.partitionmanager
    kdiff3
    wayland-utils
    wl-clipboard

    # Custom SDDM wallpaper
    (
      pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background = ${background-package}
      ''
    )
  ];

  # remove konsole and xterm
  environment.plasma6.excludePackages = [ pkgs.kdePackages.konsole ];
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.excludePackages = [ pkgs.xterm ];

  hardware.bluetooth.enable = true;

  qt = {
    enable = true;
    platformTheme = "kde6";
    style = "breeze";
  };
}
