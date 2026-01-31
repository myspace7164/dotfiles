{ pkgs, ... }:
let
  my-emacs = pkgs.emacs-pgtk;
  emacsWithPackages = (pkgs.emacsPackagesFor my-emacs).emacsWithPackages;
in
emacsWithPackages (
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
    hl-todo
    lua-mode
    magit
    markdown-mode
    minions
    move-text
    multiple-cursors
    nix-mode
    nov
    org-contacts
    pdf-tools
    plantuml-mode
    pretty-sha-path
    rust-mode
    trashed
    vterm
    yaml-mode
    zig-mode
  ])
  ++ [
    epkgs.mu4e
    epkgs.treesit-grammars.with-all-grammars
    epkgs.typst-ts-mode
    epkgs.ripgrep
  ]
)
