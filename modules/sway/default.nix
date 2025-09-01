{ config, pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      adwaita-icon-theme
      brightnessctl
      cliphist
      dex
      glib
      gnome-themes-extra
      grim
      i3status
      jq
      kanshi
      mako
      pavucontrol
      pcmanfm
      pulseaudio
      slurp
      swayidle
      swaylock
      udiskie
      wf-recorder
      wl-clipboard
      wmenu
      wtype
      xdg-user-dirs
    ];
  };

  hardware.bluetooth.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.libinput.enable = true;
  services.playerctld.enable = true;
  services.udisks2.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
