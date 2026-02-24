{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/hack-the-box.nix
    ../../modules/marlin-dav
    ../../modules/sway
    ../../modules/tubby-dav.nix
    ../../modules/virtualisation
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  networking.hostName = "thinkpad";

  services.tailscale = {
    enable = true;
		package = pkgs.unstable.tailscale;
  };
  services.tlp.enable = true;
}
