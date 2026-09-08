{
  description = "Nix configuration for my machines";

  inputs = {
    # nixos-unstable = nixpkgs-unstable + nixos testing
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-nvim = {
      url = "github:jollyroger182/nix.nvim";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-nvim,
      ...
    }:
    let
      specialArgs = hostName: flakeAttr: { inherit self hostName flakeAttr; };
      modules = [ { nixpkgs.overlays = [ nix-nvim.overlays.default ]; } ];
    in
    {
      # sudo nixos-rebuild switch --flake .#mira
      nixosConfigurations.mira = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs "mira" "nixosConfigurations";
        modules = [
          ./hosts/mira
          home-manager.nixosModules.home-manager
        ]
        ++ modules;
      };

      # sudo darwin-rebuild switch --flake .#Nico
      darwinConfigurations.Nico = nix-darwin.lib.darwinSystem {
        specialArgs = specialArgs "Nico" "darwinConfigurations";
        modules = [
          ./hosts/nico
          home-manager.darwinModules.home-manager
        ]
        ++ modules;
      };
    };
}
