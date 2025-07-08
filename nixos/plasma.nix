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
    kdePackages.kalk
    kdePackages.sddm-kcm
  ];

  hardware.bluetooth.enable = true;
}
