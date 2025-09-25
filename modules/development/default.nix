{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nixd
    nixfmt-rfc-style
    lua-language-server
    python313
    python313Packages.python-lsp-server
  ];
}
