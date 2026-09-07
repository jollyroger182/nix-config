# home-manager setup
{ self, hostName, flakeAttr, ... }:

{
  home-manager = {
    # use the system's nixpkgs
    useGlobalPkgs = true;

    # install into the system path instead of ~/.nix-profile
    useUserPackages = true;

    # rename existing dotfile instead of bail
    backupFileExtension = "hm-bak";

    extraSpecialArgs = { inherit self hostName flakeAttr; };

    users.jolly.imports = [
      ./bash.nix
      ./darwin.nix
      ./direnv.nix
      ./git.nix
      ./linux.nix
      ./neovim.nix
      ./packages.nix
    ];

    # home.stateVersion is set per host
  };
}
