{ config, lib, pkgs, ... }:
{
  xdg.configFile."systemd/user/unison-drive.service".source = ../../modules/unison/unison-drive.service;
  xdg.configFile."systemd/user/unison-usb.service".source = ../../modules/unison/unison-usb.service;

  home.file = {    
    ".unison/backup-drive.prf".source = ../../modules/unison/backup-drive.prf;
    ".unison/backup-usb.prf".source = ../../modules/unison/backup-usb.prf;
  };

  home.activation.daemonReload = lib.hm.dag.entryAfter ["writeBoundary"] ''
  ${pkgs.systemd}/bin/systemctl --user daemon-reload
  ${pkgs.systemd}/bin/systemctl --user start unison-drive.service
  ${pkgs.systemd}/bin/systemctl --user enable unison-drive.service
  ${pkgs.systemd}/bin/systemctl --user start unison-usb.service
  ${pkgs.systemd}/bin/systemctl --user enable unison-usb.service
'';
}
