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
    ddcutil
    kdePackages.kalk
    kdePackages.powerdevil
  ];

  hardware.bluetooth.enable = true;

  hardware.i2c.enable = true;
  users.users.user.extraGroups = [ "i2c" ];
}
