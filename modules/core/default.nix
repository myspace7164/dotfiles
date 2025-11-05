{ pkgs, ... }:

{
  users.users.user = {
    description = "User";
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bat
    direnv
    git
    fd
    fzf
    ripgrep
    tree
    (yazi.override {
      _7zz = _7zz-rar; # Support for RAR extraction
    })
    nixd
    nixfmt-rfc-style
    lua-language-server
    python313
    python313Packages.python-lsp-server
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  system.stateVersion = "25.05"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.flake = "github:myspace7164/dotfiles";

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  fonts.packages = with pkgs; [
    font-awesome
    iosevka
    nerd-fonts.iosevka
    noto-fonts-color-emoji
  ];
  fonts.enableDefaultPackages = true;
  fonts.fontconfig.useEmbeddedBitmaps = true;

  documentation.dev.enable = true;
  documentation.man.generateCaches = true; # https://nixos.wiki/wiki/Apropos
}
