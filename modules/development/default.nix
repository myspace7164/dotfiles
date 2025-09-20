{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    nixd
    lua-language-server
    python313
    python313Packages.python-lsp-server
  ];
}
