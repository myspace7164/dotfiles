# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = lib.mkDefault 0;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure console keymap
  console.keyMap = "sg";

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

  fonts.packages = with pkgs; [
    iosevka
    # nerdfonts
    noto-fonts-color-emoji
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    description = "User";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.overlays = [
    # (import ./overlays/steuern-lu-2024nP.nix)
  ];

  environment.systemPackages = with pkgs; [
    (aspellWithDicts (dicts: with dicts; [ de en en-computers en-science fi sv ]))
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
    fd
    gcc
    gimp
    git
    git-filter-repo
    gnucash
    gnumake
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
    neovim
    nextcloud-client
    nicotine-plus
    obs-studio
    onionshare
    p7zip
    protonvpn-gui
    python313
    qbittorrent
    reaper
    ripgrep
    rsync
    signal-desktop
    standardnotes
    # steuern-lu-2024nP
    stow
    stremio
    switcheroo
    texliveFull
    tor-browser
    tmux
    unison
    unzip
    veracrypt
    vlc
    vscode
    wget
  ];

  services.emacs = {
    enable = true;
    package = (import ./modules/emacs.nix { inherit pkgs; });
    defaultEditor = true;
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

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # shell
  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  system.stateVersion = "25.05"; # Did you read the comment?
  system.autoUpgrade.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  documentation.dev.enable = true;
  documentation.man.generateCaches = true; # https://nixos.wiki/wiki/Apropos

  # Currently unused, but nice to have as a fallback
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
