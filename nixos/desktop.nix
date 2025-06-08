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

  fileSystems."/mnt/games" =
    { device = "/dev/disk/by-uuid/d13ee898-8082-4557-b8f3-90dcc68c94de";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  networking.hostName = "desktop";
}
