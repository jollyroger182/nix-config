{ pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # stay on latest kernel for new system
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
