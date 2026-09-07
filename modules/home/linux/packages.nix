# linux-only packages
{ pkgs, ... }:

{
  # support clipboard on nvim
  home.packages = [ pkgs.wl-clipboard ];
}
