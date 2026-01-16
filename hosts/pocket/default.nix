{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot
    ../../modules/desktop
    ../../modules/sway
  ];

  networking.hostName = "pocket";

  time.timeZone = "Europe/Zurich";

  services.tlp.enable = true;

  console.keyMap = "us";
  services.xserver.xkb.layout = "us";
}
