{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/sway
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  networking.hostName = "pocket";

  console = {
    keyMap = "us";
    font = "ter-128b";
    packages = [ pkgs.terminus_font ];
  };
  services.xserver.xkb.layout = "us";

  services.tlp = {
    enable = true;
    settings = {
      DISK_DEVICES = "mmcblk0";
      DISK_IOSCHED = "deadline";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
    };
  };
}
