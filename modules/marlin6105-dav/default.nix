{ pkgs, ... }:

{
  programs.fuse = {
    enable = true;
    userAllowOther = true;
  };
  users.users.user.extraGroups = [ "fuse" ];

  systemd.user.services.rclone-marlin6105-dav-mount = {
    enable = true;
    description = "Mount marlin6105-dav via rclone";
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig =
      let
        mountDir = "/home/user/marlin6105-dav";
      in
      {
        ExecStartPre = "${pkgs.coreutils-full}/bin/mkdir -p ${mountDir}";
        ExecStart = "${pkgs.rclone}/bin/rclone mount marlin6105-dav: ${mountDir} --vfs-cache-mode writes --dir-cache-time 5s --allow-other";
        ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u ${mountDir}";
        Restart = "on-failure";
        RestartSec = 10;
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      };
  };
}
