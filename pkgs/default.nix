# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  tmux-git = pkgs.callPackage ./tmux { };
  steuern-lu-2024nP = pkgs.callPackage ./steuern-lu-2024nP { };
}
