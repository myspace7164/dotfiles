{ pkgs, ... }:
let
  myEmacs =
    with pkgs;
    ((emacsPackagesFor emacs-pgtk).emacsWithPackages (
      epkgs:
      (with epkgs.elpaPackages; [
        auctex
        gcmh
        cape
        consult
        corfu
        csv-mode
        denote
        djvu
        embark
        embark-consult
        json-mode
        marginalia
        matlab-mode
        orderless
        vertico
      ])
      ++ (with epkgs.melpaPackages; [
        cdlatex
        citar
        citar-denote
        citar-embark
        direnv
        lua-mode
        magit
        markdown-mode
        minions
        nix-mode
        org-contacts
        pdf-tools
        plantuml-mode
        yaml-mode
      ])
      ++ [
        epkgs.mu4e
        epkgs.treesit-grammars.with-all-grammars
        epkgs.ripgrep
      ]
    ));
in
{
  services.emacs = {
    enable = true;
    install = true;
    package = myEmacs;
    startWithGraphical = true;
  };

  environment.variables = {
    ALTERNATE_EDITOR = "";
    EDITOR = "emacsclient -t";
    VISUAL = "emacsclient -c -a emacs";
  };

  environment.systemPackages = with pkgs; [
    (aspellWithDicts (
      dicts: with dicts; [
        de
        en
        en-computers
        en-science
        fi
        sv
      ]
    ))
    isync
    msmtp
    mu
  ];

  services.protonmail-bridge = {
    enable = true;
    package = pkgs.protonmail-bridge;
    path = with pkgs; [ gnome-keyring ];
  };

  xdg.mime.defaultApplications = {
    "x-scheme-handler/mailto" = "emacsclient-mail.desktop";
  };
}
