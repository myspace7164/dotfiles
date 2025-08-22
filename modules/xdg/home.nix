{ config, lib, pkgs, ... }:
{
  xdg.configFile."user-dirs.dirs".source = ../../modules/xdg/user-dirs.dirs;

  #   home.activation.userDirsUpdate = lib.hm.dag.entryAfter ["linkGeneration"] ''
  #   ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update
  # '';
}
