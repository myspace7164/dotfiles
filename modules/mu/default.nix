{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    isync
    msmtp
    mu
  ];

  services.protonmail-bridge = {
    enable = true;
    package = pkgs.protonmail-bridge;
    path = with pkgs; [ gnome-keyring ];
  };
}
