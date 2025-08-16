{ config, pkgs, ... }:

{
  xdg.desktopEntries.org-protocol = {
    name = "org-protocol";
    comment = "Intercept calls from emacsclient to trigger custom actions";
    categories = [ "Utility" ];
    icon = "emacs";
    type = "Application";
    exec = "emacsclient -- %u";
    terminal = false;
    mimeType = [ "x-scheme-handler/org-protocol" ];
  };
}
