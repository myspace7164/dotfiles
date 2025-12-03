{
  inputs,
  lib,
  pkgs,
  ...
}:

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
    markdown-oxide
    nixd
    nixfmt-rfc-style
    python313
    python313Packages.python-lsp-server
    ripgrep
    texlab
    tinymist
    tree
    tree-sitter
    typst
    (yazi.override {
      _7zz = _7zz-rar; # Support for RAR extraction
    })
  ];

  programs.git = {
    enable = true;
    prompt.enable = true;
  };

  programs.neovim = {
    enable = true;
    configure = {
      customLuaRC = lib.fileContents ../../config/nvim/init.lua;
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          modus-themes-nvim
          nvim-lspconfig
          nvim-treesitter.withAllGrammars
          telescope-nvim
          typst-preview-nvim
        ];
      };
    };
  };

  programs.tmux = {
    enable = true;
    package = pkgs.tmux-git;
  };

  system.stateVersion = "25.11";
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
