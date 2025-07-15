{ config, ... }:

{
  networking.firewall.enable = false;
  
  networking.hosts = {
    "10.129.112.181" = [ "unika.htb" ];
    "10.129.119.86" = [ "thetoppers.htb" "s3.thetoppers.htb" ];
  };
}
