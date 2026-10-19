# home-manager setup
{
  pkgs,
  lib,
  self,
  hostName,
  flakeAttr,
  nix-nvim,
  sops-nix,
  ...
}:

let
  headless = builtins.elem hostName [ "orac" ];
in
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
        sops-nix
        ;
    };

    # the platform dirs are imported per-platform, so nothing inside them needs
    # its own mkIf guard. headless hosts skip the desktop bits (fonts, mpv, gui
    # apps) and sops, so a server never holds the personal tokens.
    users.jolly.imports = [
      ./bash.nix
      ./direnv.nix
      ./git.nix
      ./neovim.nix
      ./packages.nix
      ./python.nix
    ]
    ++ lib.optionals (!headless) [
      ./fonts.nix
      ./mpv.nix
      ./sops.nix
    ]
    ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin ./darwin
    ++ lib.optional (pkgs.stdenv.hostPlatform.isLinux && !headless) ./linux;

    # home.stateVersion is set per host
  };
}
