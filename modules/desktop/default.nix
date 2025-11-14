# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports = [
    ../core
    ../emacs
    ../librewolf
  ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap
  console.keyMap = "sg";
  services.xserver.xkb.layout = "ch";

  # Enable CUPS to print documents.
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    cups-brother-hll2350dw
  ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.overlays = [
    # (import ./overlays/steuern-lu-2024nP.nix)
  ];

  environment.systemPackages = with pkgs; [
    (aspellWithDicts (
      dicts: with dicts; [
        de
        en
        en-computers
        en-science
        fi
        sv
      ]
    ))
    audacity
    bitwarden
    bleachbit
    blender
    calibre
    czkawka
    darktable
    drawio
    easyeffects
    ente-auth
    ente-desktop
    ghostty
    gimp
    gnucash
    hunspell
    hunspellDicts.de_CH
    hunspellDicts.en_US
    hunspellDicts.sv_SE
    inkscape
    libreoffice
    man-pages
    man-pages-posix
    mat2
    metadata-cleaner
    mixxx
    mpv
    nextcloud-client
    nicotine-plus
    obs-studio
    onionshare
    p7zip
    protonvpn-gui
    qbittorrent
    reaper
    rsync
    signal-desktop
    standardnotes
    # steuern-lu-2024nP
    stremio
    switcheroo
    texliveFull
    tmux
    tor-browser
    unison
    unzip
    veracrypt
    vlc
    vscode
    wget
    zathura
    zotero
    (retroarch.withCores (
      cores: with cores; [
        dolphin
        mgba
        ppsspp
        snes9x
      ]
    ))
  ];

  services.syncthing = {
    openDefaultPorts = true;
    user = "user";
    dataDir = "/home/user";
    settings.devices.steamdeck.id = "2HHZQDW-2LYDBPN-AYIKXOV-BVYJURA-CZUFCXF-7TB4N5Q-W2FE36H-YRXUMAM";
    settings.devices.phone.id = "V2RPWUX-YHTMNN7-OV324QC-5S56VI7-NLZQIWI-JVMGL4P-VEJFVCQ-66IF5A4";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  programs.localsend.enable = true;
  programs.nix-ld.enable = true;
  programs.npm.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Currently unused, but nice to have as a fallback
  services.flatpak = {
    enable = false;
    packages = [ ];
  };
}
