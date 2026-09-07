{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      hostName = "Nico";
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Nico
      darwinConfigurations.${hostName} = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self hostName; };
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";
            home-manager.extraSpecialArgs = { inherit self hostName; };
            home-manager.users.jolly = import ./home.nix;
          }
        ];
      };
    };
}
