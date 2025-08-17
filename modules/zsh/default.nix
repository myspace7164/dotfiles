{ config, pkgs, ... }:

{
  users.users.user.shell = pkgs.zsh;
  
  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;

  programs.bat.enable = true;

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  
  programs.fzf.fuzzyCompletion = true;
  programs.fzf.keybindings = true;
}
