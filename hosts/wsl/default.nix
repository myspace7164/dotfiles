{ lib, ... }:

{
  imports = [
    ../../modules/core
  ];

  wsl.enable = true;
  wsl.defaultUser = "user";

  networking.hostName = "wsl";

  programs.zsh.autosuggestions.enable = lib.mkForce false;
  programs.zsh.syntaxHighlighting.enable = lib.mkForce false;
}
