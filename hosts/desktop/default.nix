{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/sway
    ../../modules/virtualisation
  ];

  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  fileSystems."/mnt/drive" = {
    device = "/dev/disk/by-uuid/62dc23af-e608-415a-85e9-5267d179a3d3";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/d13ee898-8082-4557-b8f3-90dcc68c94de";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  networking.hostName = "desktop";

  # External monitor backlight control
  boot.extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
  boot.kernelModules = [ "ddcci-backlight" ];
  services.udev.extraRules =
    let
      bash = "${pkgs.bash}/bin/bash";
      ddcciDev = "AMDGPU DM aux hw bus 0";
      ddcciNode = "/sys/bus/i2c/devices/i2c-9/new_device";
    in
    ''
      SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="${ddcciDev}", RUN+="${bash} -c 'sleep 30; printf ddcci\ 0x37 > ${ddcciNode}'"
    '';

  services.syncthing.settings.folders."dig4718".path = "/mnt/drive/dig4718";

  systemd.user.services.unison-dig4718 = {
    enable = true;
    wantedBy = [ "default.target" ];
    description = "Unison default service";
    serviceConfig = {
      ExecStart = "${pkgs.unison}/bin/unison sync-dig4718";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
