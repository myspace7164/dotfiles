{ pkgs, ... }:
{
  services.emacs = {
    enable = true;
    install = true;
    package =
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
          org-caldav
          org-contacts
          plantuml-mode
          yaml-mode
        ])
        ++ [
          epkgs.mu4e
          epkgs.treesit-grammars.with-all-grammars
          epkgs.ripgrep
        ]
      ));
    startWithGraphical = true;
  };

  environment.variables = {
    ALTERNATE_EDITOR = "";
    EDITOR = "emacsclient -t";
    VISUAL = "emacsclient -c -a emacs";
  };

  environment.systemPackages = with pkgs; [
    isync
    msmtp
    mu
  ];

  services.protonmail-bridge = {
    enable = true;
    package = pkgs.protonmail-bridge;
    path = with pkgs; [ gnome-keyring ];
  };
}
