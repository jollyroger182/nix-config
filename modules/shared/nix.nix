# nix + nixpkgs settings
{ self, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    trusted-users = [ "jolly" ];
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;
}
