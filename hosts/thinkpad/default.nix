{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../..
    ../../modules/boot
    ../../modules/hack-the-box.nix
		../../modules/plymouth
    ../../modules/sway
    ../../modules/virtualisation
  ];

  networking.hostName = "thinkpad";

  time.timeZone = "Europe/Zurich";

  services.syncthing = {
    enable = true;
    settings.folders."~/Nextcloud/games".devices = [
      "phone"
      "steamdeck"
    ];
  };
}
