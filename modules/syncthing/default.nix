{ lib, ... }:
let
  all = [
    "desktop"
    "device"
    "marlin6105"
    "player"
    "pocket"
    "steamdeck"
    "thinkpad"
  ];
in
{
  networking.firewall.allowedTCPPorts = [ 8384 ];

  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = true;
    user = "user";
    dataDir = lib.mkDefault "/home/user";

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
      "~/archive".devices = ["marlin6105" "thinkpad"];
      "~/audio".devices = ["marlin6105" "thinkpad"];
      "~/backup".devices = ["marlin6105" "thinkpad"];
      "~/documents".devices = ["marlin6105" "thinkpad"];
      "~/games".devices = all;
      "~/hosts".devices = ["marlin6105" "thinkpad"];
      "~/inbox".devices = ["marlin6105" "thinkpad"];
      "~/music".devices = ["marlin6105" "thinkpad"];
      "~/notes".devices = ["marlin6105" "thinkpad"];
      "~/org".devices = all;
      "~/pictures".devices = ["marlin6105" "thinkpad"];
      "~/projects".devices = ["marlin6105" "thinkpad"];
      "~/recovery".devices = ["marlin6105" "thinkpad"];
      "~/templates".devices = ["marlin6105" "thinkpad"];
      "~/video".devices = ["marlin6105" "thinkpad"];
    };
  };
}
