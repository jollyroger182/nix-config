# orac - Oracle Cloud free-tier Ampere A1 VM (aarch64)
{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/shared/nix.nix
    ../../modules/shared/overlays.nix
    ../../modules/shared/packages.nix
    ../../modules/shared/ssh.nix
    ../../modules/home

    ../../modules/nixos/sudo.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/user.nix
  ];

  networking.hostName = "orac";

  # Installed with nixos-infect over Oracle Linux, so the disk layout is the
  # one Oracle's image shipped with: a 100 MB ESP mounted at /boot/efi holding
  # grub, with kernels living on the root filesystem.
  boot.loader = {
    efi.efiSysMountPoint = "/boot/efi";
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  # Root is an LVM logical volume (ocivolume/root). The systemd initrd only
  # activates LVM when asked to.
  boot.initrd.services.lvm.enable = true;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  # Same meaning as system.stateVersion but tracked separately by
  # home-manager, and different per machine. Set once, then leave it alone.
  home-manager.users.jolly.home.stateVersion = "25.05";

  # First NixOS version installed on this machine. Never change it.
  system.stateVersion = "25.05";
}
