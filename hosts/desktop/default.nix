{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../..
    ../../modules/boot
    ../../modules/development
    ../../modules/plasma
    ../../modules/plymouth
    ../../modules/virtualisation
  ];

  boot.loader.timeout = 0;
  boot.loader.systemd-boot.enable = false;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/d13ee898-8082-4557-b8f3-90dcc68c94de";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  networking.hostName = "desktop";

  services.xserver.enable = true;
  services.xserver.xkb.layout = "ch";

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

    ddcutil
    kdePackages.powerdevil
  ];

  # SDDM specific
  services.displayManager.sddm.settings = {
    Wayland = {
      CompositorCommand =
        let
        westonIni = (pkgs.formats.ini { }).generate "weston.ini" {
          libinput = {
            enable-tap = config.services.libinput.mouse.tapping;
            left-handed = config.services.libinput.mouse.leftHanded;
          };
          keyboard = {
            keymap_model = config.services.xserver.xkb.model;
            keymap_layout = config.services.xserver.xkb.layout;
            keymap_variant = config.services.xserver.xkb.variant;
            keymap_options = config.services.xserver.xkb.options;
          };
          output = {
            transform = "normal";
          };
        };
      in
      "${pkgs.weston}/bin/weston --shell=kiosk -c ${westonIni} --refresh-rate=165,000";
    };
  };

  # External monitor backlight control
  hardware.i2c.enable = true;
  users.users.user.extraGroups = [ "i2c" ];
}
