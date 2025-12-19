{ ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "user";
    dataDir = "/home/user";

    settings.devices = {
      desktop.id = "QGPMTZJ-RKIH4T6-AWTM5LT-GAWTTAP-PTYR3Z7-UNQKIPC-ENS5JN4-W635BAV";
      device.id = "V2RPWUX-YHTMNN7-OV324QC-5S56VI7-NLZQIWI-JVMGL4P-VEJFVCQ-66IF5A4";
      player.id = "MQPAXMC-J25TPXE-2TPZUWJ-RHRRSEM-SUZBLQQ-QHGL7YY-O52KPPT-CDXTBQO";
      steamdeck.id = "2HHZQDW-2LYDBPN-AYIKXOV-BVYJURA-CZUFCXF-7TB4N5Q-W2FE36H-YRXUMAM";
      thinkpad.id = "6EF3BXL-PNMEQHU-6Z6GUAS-6QWSCEL-J37NOFE-YOJVMR4-QU76ERV-N7JEJAO";
    };

    settings.folders = {
      "~/Nextcloud/games".devices = [ "steamdeck" ];
      "~/org" = {
        devices = [
          "device"
          "thinkpad"
        ];
      };
    };
  };
}
