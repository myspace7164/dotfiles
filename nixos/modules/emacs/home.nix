{ config, pkgs, ... }:

{
  home.file.".emacs.d/init.el".source = ./init.el;
  home.file.".emacs.d/early-init.el".source = ./early-init.el;
  home.file.".local/share/applications/org-protocol.desktop".source = ./org-protocol.desktop;
}
