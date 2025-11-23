{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot
    ../../modules/desktop
    ../../modules/gnome
    ../../modules/plymouth
  ];

  networking.hostName = "player";

  services.xserver.xkb.layout = "ch";

  services.syncthing = {
    enable = true;
    settings.folders."~/Nextcloud/games".devices = [ "device" "steamdeck" ];
  };

  system.autoUpgrade.allowReboot = true;

  systemd.tmpfiles.rules =
    let
      monitors.xml = pkgs.writeText "monitors.xml" ''
        <monitors version="2">
        	<configuration>
        		<layoutmode>physical</layoutmode>
        		<logicalmonitor>
        			<x>0</x>
        			<y>0</y>
        			<scale>1</scale>
        			<primary>yes</primary>
        			<monitor>
        				<monitorspec>
        					<connector>HDMI-1</connector>
        					<vendor>XGM</vendor>
        					<product>XGIMI TV</product>
        					<serial>0x00000001</serial>
        				</monitorspec>
        				<mode>
        					<width>1920</width>
        					<height>1080</height>
        					<rate>60.000</rate>
        				</mode>
        			</monitor>
        		</logicalmonitor>
        	</configuration>
        </monitors>
      '';
    in
    [
      "L /run/gdm/.config/monitors.xml - - - - ${monitors.xml}"
    ];
}
