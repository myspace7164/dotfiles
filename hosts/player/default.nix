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
    settings.folders."~/cloud/games".devices = [ "steamdeck" ];
    settings.folders."~/cloud/org".devices = [ "phone" ];
  };

  system.autoUpgrade.allowReboot = true;
}
