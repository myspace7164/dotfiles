{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs-pgtk).emacsWithPackages (
      epkgs:
      (with epkgs.elpaPackages; [
        cape
        consult
        corfu
        csv-mode
        embark
        embark-consult
        json-mode
        marginalia
        matlab-mode
        orderless
        vertico
      ])
      ++ (with epkgs.melpaPackages; [
        direnv
        lua-mode
        magit
        markdown-mode
        minions
        nix-mode
        plantuml-mode
        yaml-mode
      ])
      ++ [
        epkgs.ripgrep
        epkgs.treesit-grammars.with-all-grammars
      ]
    ))
  ];
}
