{ pkgs, lib, ... }:
{
  imports = [
    ../core
    ../emacs
    ../librewolf
    ../syncthing
    ../users
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
  console.keyMap = lib.mkDefault "sg";
  services.xserver.xkb.layout = lib.mkDefault "ch";

  # Enable CUPS to print documents.
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    cnijfilter2
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

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings.PasswordAuthentication = false;
  };

  systemd.user.services.unison-default = {
    enable = true;
    wantedBy = [ "default.target" ];
    description = "Unison default service";
    serviceConfig = {
      ExecStart = "${pkgs.unison}/bin/unison /home/user /run/media/user/dig4718 -path org -perms 0 -batch -auto -repeat watch";
      Restart = "always";
      RestartSec = 10;
    };
  };

  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    ente-auth
    ente-desktop
    mixxx
    mpv
    protonvpn-gui
    signal-desktop
    spotify
    tor-browser
    unison
    zathura
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
