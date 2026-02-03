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
  services.tlp.enable = true;
}
