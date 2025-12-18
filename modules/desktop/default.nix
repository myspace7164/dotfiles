{ pkgs, lib, ... }:
{
  imports = [
    ../core
    ../emacs
    ../librewolf
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod.type = "ibus";
  i18n.inputMethod.enable = true;

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

  environment.systemPackages = with pkgs; [
    audacity
    bitwarden-desktop
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
    inkscape
    libreoffice
    mat2
    metadata-cleaner
    mixxx
    mpv
    steuern-lu-2024nP
    nextcloud-client
    nicotine-plus
    obs-studio
    onionshare
    protonvpn-gui
    qbittorrent
    reaper
    signal-desktop
    standardnotes
    switcheroo
    tor-browser
    unison
    veracrypt
    vlc
    vscode
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

  xdg.mime.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };

  services.syncthing = {
    openDefaultPorts = true;
    user = "user";
    dataDir = "/home/user";
    settings.devices.device.id = "V2RPWUX-YHTMNN7-OV324QC-5S56VI7-NLZQIWI-JVMGL4P-VEJFVCQ-66IF5A4";
    settings.devices.player.id = "MQPAXMC-J25TPXE-2TPZUWJ-RHRRSEM-SUZBLQQ-QHGL7YY-O52KPPT-CDXTBQO";
    settings.devices.steamdeck.id = "2HHZQDW-2LYDBPN-AYIKXOV-BVYJURA-CZUFCXF-7TB4N5Q-W2FE36H-YRXUMAM";
    settings.devices.thinkpad.id = "6EF3BXL-PNMEQHU-6Z6GUAS-6QWSCEL-J37NOFE-YOJVMR4-QU76ERV-N7JEJAO";
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
    enable = true;
    uninstallUnmanaged = true;
    packages = [ "com.stremio.Stremio" ];
  };
}
