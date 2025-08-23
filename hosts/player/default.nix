{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../..
    ../../modules/gnome
  ];

  networking.hostName = "player";

  services.xserver.xkb.layout = "ch";

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "user";
    dataDir = "/home/user";
    settings.devices.steamdeck.id = "2HHZQDW-2LYDBPN-AYIKXOV-BVYJURA-CZUFCXF-7TB4N5Q-W2FE36H-YRXUMAM";
    settings.folders."~/cloud/games".devices = [ "steamdeck" ];
  };

  system.autoUpgrade.allowReboot = true;
}
