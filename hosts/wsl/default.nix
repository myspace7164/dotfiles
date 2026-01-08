{ ... }:

{
  imports = [
    ../../modules/core
    ../../modules/emacs
  ];

  wsl.enable = true;
  wsl.defaultUser = "user";

  networking.hostName = "wsl";
}
