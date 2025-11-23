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

  services.syncthing = {
    enable = true;
    settings.folders."~/Nextcloud/games".devices = [
      "device"
      "steamdeck"
    ];
    settings.folders."~/Nextcloud/obsidian".devices = [ "device" ];
  };
}
