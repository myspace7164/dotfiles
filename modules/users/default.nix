{ ... }:

let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPFGU9RU0wnVwaQDKQ4iBl3eQY7BZ4JYySdm2VJX6a0u openpgp:0x5D22FFF4"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEer3YY0MwMQdlJK/MNybT1pKxbqNkwBpjHkvTq1xGiw u0_a446@localhost"
  ];
in
{
  users = {
    users.user = {
      description = "User";
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = keys;
    };
    users.root.openssh.authorizedKeys.keys = keys;
  };
}
