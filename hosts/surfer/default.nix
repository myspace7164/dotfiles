{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/hack-the-box.nix
    ../../modules/marlin-dav.nix
    ../../modules/sway.nix
    ../../modules/tubby-dav.nix
    ../../modules/virtualisation.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  networking.hostName = "surfer";

  services.tailscale = {
    enable = true;
		package = pkgs.unstable.tailscale;
  };
  services.tlp.enable = true;
}
