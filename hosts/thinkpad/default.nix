{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../..
    ../../modules/boot
    ../../modules/development
    ../../modules/sway
    ../../modules/virtualisation
    ../../modules/hack-the-box.nix
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
