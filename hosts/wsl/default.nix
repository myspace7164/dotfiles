{ ... }:

{
  imports = [
    ../../modules/core.nix
    ../../modules/emacs.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "user";

  networking.hostName = "wsl";

  environment.variables.GTK_THEME = "Adwaita:dark";
}
