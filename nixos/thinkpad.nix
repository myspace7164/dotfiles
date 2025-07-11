{ config, pkgs, ... }:

let
  background-package = pkgs.runCommand "background-image" {} ''
  cp ${../assets/10-3-6k.jpg} $out
'';
in
{
  imports = [
    ./configuration.nix
    ./plasma.nix
    ./virtualisation.nix
  ];

  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

  boot = {
    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

  networking.hostName = "thinkpad";

  services.displayManager.sddm.wayland.enable = true;

  environment.systemPackages = with pkgs; [
    # Custom SDDM wallpaper
    (
      pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background = ${background-package}
      ''
    )
  ];
}
