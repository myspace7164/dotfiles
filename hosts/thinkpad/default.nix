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

  environment.systemPackages = with pkgs; [
    unstable.rclone
  ];

  services.tlp.enable = true;
  services.davfs2.enable = true;

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820;
      privateKeyFile = "/home/user/wireguard-keys/private";
      peers = [
        {
          publicKey = "nAhX+IQOU/UTkrVzev+DrGZ5X1oIUFqXE01xuZf/L1M=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "reissue9478.servecounterstrike.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
