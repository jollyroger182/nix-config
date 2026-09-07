{
  description = "Nix configuration for my machines";

  inputs = {
    # Both machines track one nixpkgs. nixos-unstable is nixpkgs-unstable gated
    # on NixOS's release-critical tests passing, which is worth having on mira
    # and harmless on Nico.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      # hostName and flakeAttr let a module work out which configuration it is
      # being evaluated as part of, which modules/home/neovim.nix needs to
      # point nixd at the right option tree.
      specialArgs = hostName: flakeAttr: { inherit self hostName flakeAttr; };
    in
    {
      # sudo nixos-rebuild switch --flake .#mira
      nixosConfigurations.mira = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs "mira" "nixosConfigurations";
        modules = [
          ./hosts/mira
          home-manager.nixosModules.home-manager
        ];
      };

      # darwin-rebuild switch --flake .#Nico
      darwinConfigurations.Nico = nix-darwin.lib.darwinSystem {
        specialArgs = specialArgs "Nico" "darwinConfigurations";
        modules = [
          ./hosts/nico
          home-manager.darwinModules.home-manager
        ];
      };
    };
}
