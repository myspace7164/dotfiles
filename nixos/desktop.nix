{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./sway.nix
    ./virtualisation.nix
  ];

  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = false;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "desktop";
}
