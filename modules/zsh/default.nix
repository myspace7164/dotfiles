{ pkgs, ... }:

{
  users.users.user.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    bat
    direnv
    fd
    fzf
    ripgrep
    tree
    (yazi.override {
      _7zz = _7zz-rar; # Support for RAR extraction
    })
  ];

  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
}
