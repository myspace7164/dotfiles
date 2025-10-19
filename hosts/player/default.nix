{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../..
    ../../modules/boot
    ../../modules/gnome
    ../../modules/plymouth
  ];

  networking.hostName = "player";

  services.xserver.xkb.layout = "ch";

  services.syncthing = {
    enable = true;
    settings.folders."~/Nextcloud/games".devices = [ "steamdeck" ];
    settings.folders."~/Nextcloud/org".devices = [ "phone" ];
  };

  system.autoUpgrade.allowReboot = true;
}
