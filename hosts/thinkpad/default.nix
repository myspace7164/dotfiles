{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/hack-the-box.nix
    ../../modules/marlin6105-dav
    ../../modules/sway
    ../../modules/virtualisation
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  networking.hostName = "thinkpad";

  services.tlp.enable = true;
  services.davfs2.enable = true;

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      privateKeyFile = "/home/user/wireguard-keys/private";
      peers = [
        {
          publicKey = "nAhX+IQOU/UTkrVzev+DrGZ5X1oIUFqXE01xuZf/L1M=";
          allowedIPs = [ "192.168.1.0/24" ];
          endpoint = "reissue9478.servecounterstrike.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
