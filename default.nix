# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports = [
    ./modules/zsh
  ];

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
    nerd-fonts.iosevka
    noto-fonts-color-emoji
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    description = "User";
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
    git
    git-filter-repo
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
    ((emacsPackagesFor emacs).emacsWithPackages (
      epkgs:
      (with epkgs.elpaPackages; [
        auctex
        gcmh
        cape
        consult
        corfu
        csv-mode
        denote
        djvu
        embark
        embark-consult
        json-mode
        marginalia
        matlab-mode
        orderless
        standard-themes
        vertico
      ])
      ++ (with epkgs.melpaPackages; [
        cdlatex
        citar
        citar-denote
        citar-embark
        dired-subtree
        direnv
        lua-mode
        magit
        markdown-mode
        minions
        move-text
        nix-mode
        nov
        org-pdftools
        pdf-tools
        plantuml-mode
        saveplace-pdf-view
        yaml-mode
      ])
      ++ [
        epkgs.treesit-grammars.with-all-grammars
        pkgs.ripgrep
      ]
    ))
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

  # librewolf
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      DisableFirefoxAccounts = true;
      ExtensionSettings = {
        # addy.io
        "browser-extension@anonaddy" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/addy_io/latest.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # floccus
        "floccus@handmadeideas.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/floccus/latest.xpi";
          installation_mode = "force_installed";
        };
        # Org Capture
        "{ddefd400-12ea-4264-8166-481f23abaa87}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/org-capture/latest.xpi";
          installation_mode = "force_installed";
        };
        # Proton Pass
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
          installation_mode = "force_installed";
        };
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Vimium C
        "vimium-c@gdh1995.cn" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      SearchEngines = {
        Default = "DuckDuckGo";
      };
    };
  };
  environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
  xdg.mime.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };

  programs.localsend.enable = true;
  programs.nix-ld.enable = true;
  programs.npm.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  system.stateVersion = "25.05"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.flake = "github:myspace7164/dotfiles";

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  documentation.dev.enable = true;
  documentation.man.generateCaches = true; # https://nixos.wiki/wiki/Apropos

  # Currently unused, but nice to have as a fallback
  services.flatpak = {
    enable = false;
    packages = [ ];
  };
}
