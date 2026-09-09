# home-manager setup
{
  pkgs,
  lib,
  self,
  hostName,
  flakeAttr,
  nix-nvim,
  ...
}:

{
  home-manager = {
    # use the system's nixpkgs
    useGlobalPkgs = true;

    # install into the system path instead of ~/.nix-profile
    useUserPackages = true;

    # rename existing dotfile instead of bail
    backupFileExtension = "hm-bak";

    extraSpecialArgs = {
      inherit
        self
        hostName
        flakeAttr
        nix-nvim
        ;
    };

    # the platform dirs are imported per-platform, so nothing inside them needs
    # its own mkIf guard
    users.jolly.imports = [
      ./bash.nix
      ./direnv.nix
      ./fonts.nix
      ./git.nix
      ./neovim.nix
      ./packages.nix
      ./python.nix
    ]
    ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin ./darwin
    ++ lib.optional pkgs.stdenv.hostPlatform.isLinux ./linux;

    # home.stateVersion is set per host
  };
}
