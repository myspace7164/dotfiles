{ config, pkgs, ... }:

let
  background-package = pkgs.runCommand "background-image" {} ''
  cp ${../assets/10-3-6k.jpg} $out
'';
in
{
  imports = [
    ./configuration.nix
    ./plasma.nix
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

  # AMD related
  hardware = {
    enableAllFirmware = true;

    graphics.enable = true;
    graphics.enable32Bit = true;

    amdgpu.initrd.enable = true;
    amdgpu.amdvlk.enable = true;
    amdgpu.amdvlk.support32Bit.enable = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  programs.steam.extraPackages = with pkgs; [
    gamescope
    rpcs3
  ];

  environment.systemPackages = with pkgs; [
    gamescope
    rpcs3

    # AMD related
    mesa
    vulkan-loader
    vulkan-tools

    # Custom SDDM wallpaper
    (
      pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background = ${background-package}
      ''
    )
  ];

  # SDDM specific
  services.displayManager.sddm.wayland.enable = false;
  services.xserver.displayManager.setupCommands = ''
  ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-0 --primary --mode 3440x1440 --pos 0x0 --rotate normal \
                                 --output DisplayPort-0 --mode 1920x1080 --pos 3440x0 --rate 165 --rotate normal
'';
}
