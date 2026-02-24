{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/hack-the-box.nix
    ../../modules/marlin-dav
    ../../modules/sway
    ../../modules/virtualisation
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/media" = {
    device = "100.70.70.7:/volume1/media";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
    ];
  };

  networking.hostName = "thinkpad";

  services.tailscale = {
    enable = true;
		package = pkgs.unstable.tailscale;
  };
  services.tlp.enable = true;
}
