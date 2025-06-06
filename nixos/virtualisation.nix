{ config, pkgs, ... }:

{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["user"];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];

  virtualisation.spiceUSBRedirection.enable = true;
}
