# Nico - MacBook with nix-darwin
{ ... }:

{
  imports = [
    ../../modules/shared/nix.nix
    ../../modules/shared/overlays.nix
    ../../modules/shared/packages.nix
    ../../modules/shared/postgres.nix
    ../../modules/shared/ssh.nix
    ../../modules/home

    ../../modules/darwin/defaults.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/user.nix
  ];

  # Same meaning as system.stateVersion but tracked separately by
  # home-manager, and different per machine. Set once, then leave it alone.
  home-manager.users.jolly.home.stateVersion = "26.11";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
