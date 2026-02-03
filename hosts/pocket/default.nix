{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot
    ../../modules/desktop
    ../../modules/sway
  ];

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
