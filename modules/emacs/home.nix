{ config, lib, pkgs, ... }:
{
  home.file = {
    ".emacs.d/init.el".source = ../../modules/emacs/init.el;
    ".emacs.d/early-init.el".source = ../../modules/emacs/early-init.el;
  };

  xdg.dataFile."applications/org-protocol.desktop".source = ../../modules/emacs/org-protocol.desktop;

  home.activation.updateDesktopDatabase = lib.hm.dag.entryAfter ["writeBoundary"] ''
  ${pkgs.desktop-file-utils}/bin/update-desktop-database ~/.local/share/applications
'';
}
