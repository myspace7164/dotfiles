{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../..
    ../../modules/gnome
    ../../modules/plymouth
  ];

  networking.hostName = "player";

  services.xserver.xkb.layout = "ch";

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "user";
    dataDir = "/home/user";
    settings.devices.steamdeck.id = "2HHZQDW-2LYDBPN-AYIKXOV-BVYJURA-CZUFCXF-7TB4N5Q-W2FE36H-YRXUMAM";
    settings.devices.phone.id = "Y7ATORA-7CQMLAN-XLYMSCB-RKCUWRJ-CCBOW4E-A3WM3GZ-FIH3PLW-JT6OTQL";
    settings.folders."~/cloud/games".devices = [ "steamdeck" ];
    settings.folders."~/cloud/org".devices = [ "phone" ];
  };

  system.autoUpgrade.allowReboot = true;
}
