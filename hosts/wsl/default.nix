{ lib, ... }:

{
  imports = [
    ../../modules/core
  ];

  wsl.enable = true;
  wsl.defaultUser = "user";

  networking.hostName = "wsl";
}
