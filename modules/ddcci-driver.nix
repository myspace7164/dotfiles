{ config, pkgs, ... }:

{
  # Here for future reference :)
  # https://wiki.nixos.org/wiki/Backlight#brightnessctl

  boot.extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
  boot.kernelModules = [ "ddcci-backlight" ];

  # Use ddcutil and cat /sys/bus/i2c/devices/*/name to get the info
  services.udev.extraRules =
    let
      bash = "${pkgs.bash}/bin/bash";
    in
    ''
      SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="AMDGPU DM i2c hw bus 3", RUN+="${bash} -c 'sleep 30; printf ddcci\ 0x37 > /sys/bus/i2c/devices/i2c-8/new_device'"
      SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="AMDGPU DM aux hw bus 0", RUN+="${bash} -c 'sleep 30; printf ddcci\ 0x37 > /sys/bus/i2c/devices/i2c-9/new_device'"
    '';
}
