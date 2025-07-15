{ config, pkgs, ... }:

let
  background-package = pkgs.runCommand "background-image" {} ''
  cp ${../../assets/10-3-6k.jpg} $out
'';
in
{
  # Enable the Plasma 6 (KDE 6) Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
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
    kdiff3
    wayland-utils
    wezterm
    wl-clipboard

    # Custom SDDM wallpaper
    (
      pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background = ${background-package}
      ''
    )
  ];

  environment.plasma6.excludePackages = [ pkgs.kdePackages.konsole ];

  hardware.bluetooth.enable = true;

  qt = {
    enable = true;
    platformTheme = "kde6";
    style = "breeze";
  };
}
