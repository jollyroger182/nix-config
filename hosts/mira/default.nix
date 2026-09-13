# mira - nixos laptop
{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/shared/nix.nix
    ../../modules/shared/overlays.nix
    ../../modules/shared/packages.nix
    ../../modules/shared/postgres.nix
    ../../modules/shared/ssh.nix
    ../../modules/home

    ../../modules/nixos/boot.nix
    ../../modules/nixos/cube-direct.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/networkmanager.nix
    ../../modules/nixos/nix-ld.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/sudo.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/user.nix
  ];

  networking.hostName = "mira";

  # Same meaning as system.stateVersion but tracked separately by
  # home-manager, and different per machine. Set once, then leave it alone.
  home-manager.users.jolly.home.stateVersion = "26.05";

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any
  # reason, even if you've upgraded your system to a new NixOS release. It does
  # NOT affect the nixpkgs version your packages come from, and a value lower
  # than the current release does NOT mean your system is out of date or
  # unsupported. See https://nixos.org/manual/nixos/stable/#sec-upgrading.
  system.stateVersion = "26.05";
}
