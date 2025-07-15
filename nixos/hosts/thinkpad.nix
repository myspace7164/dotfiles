{ config, pkgs, ... }:

{
  imports = [
    ../configuration.nix
    ../modules/hack-the-box.nix
    ../modules/plasma.nix
    ../modules/virtualisation.nix
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

  services.xserver.xkb.layout = "ch";
}
