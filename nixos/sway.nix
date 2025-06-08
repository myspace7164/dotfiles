{ config, pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
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
      wezterm
      wf-recorder
      wl-clipboard
      wmenu
      wtype
    ];
  };

  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.udisks2.enable = true;
  services.playerctld.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
