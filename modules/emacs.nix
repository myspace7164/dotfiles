{ pkgs, ... }:

{
  services.emacs = {
    enable = true;
    install = true;
    package = pkgs.my-emacs;
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
