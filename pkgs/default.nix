# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  my-tmux-git = pkgs.callPackage ./tmux { };
	my-steuern-lu-2024nP = pkgs.callPackage ./steuern-lu-2024nP { };
}
