# neovim, configured at https://github.com/jollyroger182/nix.nvim
{ pkgs, ... }:

{
  home.packages = [
    pkgs.nvim-pkg
  ];
}
