{ config, pkgs, ... }:

{
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  # Enable "Silent boot"
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"
  ];
}
