{ pkgs, ... }:

{
  programs.fuse = {
    enable = true;
    userAllowOther = true;
  };
  users.users.user.extraGroups = [ "fuse" ];

  systemd.user.services.rclone-tubby-dav-mount = {
    enable = true;
    description = "Mount tubby-dav via rclone";
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig =
      let
        mountDir = "/home/user/tubby-dav";
      in
      {
        ExecStartPre = "${pkgs.coreutils-full}/bin/mkdir -p ${mountDir}";
        ExecStart = "${pkgs.unstable.rclone}/bin/rclone mount tubby-dav: ${mountDir} --vfs-cache-mode writes --dir-cache-time 5s --allow-other";
        ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u ${mountDir}";
        Restart = "on-failure";
        RestartSec = 10;
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      };
  };
}
