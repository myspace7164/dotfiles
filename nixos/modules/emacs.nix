{ pkgs ? import <nixpkgs> {} }:

let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
])
++ (with epkgs.melpaPackages; [
  cdlatex
  citar
  citar-denote
  citar-embark
  dired-subtree
  direnv
  magit
  markdown-mode
  minions
  move-text
  nix-mode
  nov
  org-caldav
  org-contacts
  org-pdftools
  pdf-tools
  plantuml-mode
  saveplace-pdf-view
])
++ (with epkgs.elpaPackages; [
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
  standard-themes
  undo-tree
  vertico
])
++ [
  epkgs.mu4e
])
