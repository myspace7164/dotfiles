{ ... }:

let
  keyFiles = [
    "../../hosts/player/id_rsa.pub"
    "../../hosts/thinkpad/id_rsa.pub"
  ];
in
{
  users = {
    mutableUsers = false;
    users.user = {
      description = "User";
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keyFiles = keyFiles;
    };
    users.root.openssh.authorizedKeys.keyFiles = keyFiles;
  };
}
