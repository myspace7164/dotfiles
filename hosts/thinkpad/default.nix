{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot
    ../../modules/desktop
    ../../modules/hack-the-box.nix
    ../../modules/sway
    ../../modules/virtualisation
  ];

  networking.hostName = "thinkpad";

  time.timeZone = "Europe/Zurich";

  services.tlp.enable = true;
}
