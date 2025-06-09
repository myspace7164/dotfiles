{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./gnome.nix
  ];

  networking.hostName = "player";

  services.syncthing = {
    enable = true;
    user = "user";
    dataDir = "/home/user";
    settings.devices.steamdeck.id = "2HHZQDW-2LYDBPN-AYIKXOV-BVYJURA-CZUFCXF-7TB4N5Q-W2FE36H-YRXUMAM";
    settings.folders."~/cloud/games".devices = [ "steamdeck" ];
  };

  system.autoUpgrade.allowReboot = true;
}
