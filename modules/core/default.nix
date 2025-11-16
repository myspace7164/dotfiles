{ inputs, pkgs, ... }:

{
  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
    ];
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.user = {
    description = "User";
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    bat
    direnv
    git-filter-repo
    fd
    fzf
    lazygit
    lua-language-server
    nixd
    nixfmt-rfc-style
    python313
    python313Packages.python-lsp-server
    ripgrep
    texlab
    tree
    (yazi.override {
      _7zz = _7zz-rar; # Support for RAR extraction
    })
  ];

  programs.git = {
    enable = true;
    prompt.enable = true;
  };

  programs.tmux = {
    enable = true;
    package = pkgs.my-tmux-git;
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
