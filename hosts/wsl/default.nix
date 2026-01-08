{ ... }:

{
  imports = [
    ../../modules/core
    ../../modules/emacs
  ];

  wsl.enable = true;
  wsl.defaultUser = "user";

  networking.hostName = "wsl";

  environment.variables.GTK_THEME = "Adwaita:dark";
}
