{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./sway.nix
    ./virtualisation.nix
  ];

  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = false;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  fileSystems."/mnt/games" =
    { device = "/dev/disk/by-uuid/d13ee898-8082-4557-b8f3-90dcc68c94de";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  networking.hostName = "desktop";

  # Use ddcutil and cat /sys/bus/i2c/devices/*/name to get the info
  services.udev.extraRules = let
    bash = "${pkgs.bash}/bin/bash";
  in ''
      SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="AMDGPU DM i2c hw bus 3", RUN+="${bash} -c 'sleep 5; printf ddcci\ 0x37 > /sys/bus/i2c/devices/i2c-8/new_device'"
      SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="AMDGPU DM aux hw bus 0", RUN+="${bash} -c 'sleep 5; printf ddcci\ 0x37 > /sys/bus/i2c/devices/i2c-9/new_device'"
    '';
}
