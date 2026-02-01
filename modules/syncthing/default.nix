{ ... }:
{
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = true;
    user = "user";
    dataDir = "/home/user";

    settings.devices = {
      desktop.id = "QGPMTZJ-RKIH4T6-AWTM5LT-GAWTTAP-PTYR3Z7-UNQKIPC-ENS5JN4-W635BAV";
      device.id = "V2RPWUX-YHTMNN7-OV324QC-5S56VI7-NLZQIWI-JVMGL4P-VEJFVCQ-66IF5A4";
      marlin6105.id = "R6TVQLH-5ZXEK6O-4JIZEJ6-FZWBUZQ-BHQRIT4-IEQQT7I-V6SASNJ-OVCV3AG";
      player.id = "MQPAXMC-J25TPXE-2TPZUWJ-RHRRSEM-SUZBLQQ-QHGL7YY-O52KPPT-CDXTBQO";
      pocket.id = "GXR6U4A-4FDR47D-5EUJUMI-YCQMIOD-K2YAIOD-X2PUZ4Y-RXC57PU-L3ZTZQY";
      steamdeck.id = "2HHZQDW-2LYDBPN-AYIKXOV-BVYJURA-CZUFCXF-7TB4N5Q-W2FE36H-YRXUMAM";
      thinkpad.id = "6EF3BXL-PNMEQHU-6Z6GUAS-6QWSCEL-J37NOFE-YOJVMR4-QU76ERV-N7JEJAO";
    };

    settings.folders = {
      "~/Nextcloud/games".devices = [ "steamdeck" ];
      "~/org".devices = [
        "desktop"
        "device"
        "marlin6105"
        "player"
        "pocket"
        "steamdeck"
        "thinkpad"
      ];
      "SeedVaultAndroidBackup" = {
        id = "ojr5r-owslz";
        devices = [
          "marlin6105"
          "player"
        ];
      };
    };
  };
}
