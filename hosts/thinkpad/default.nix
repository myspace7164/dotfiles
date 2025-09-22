{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../..
    ../../modules/development
    ../../modules/sway
    ../../modules/virtualisation
    ../../modules/hack-the-box.nix
  ];

  networking.hostName = "thinkpad";

  time.timeZone = "Europe/Zurich";

  services.syncthing = {
    enable = true;
    settings.folders."~/cloud/games".devices = [ "steamdeck" ];
    settings.folders."~/cloud/org".devices = [ "phone" ];
  };
}
