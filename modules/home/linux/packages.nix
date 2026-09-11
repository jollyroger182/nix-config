# linux-only packages
{ pkgs, ... }:

{
  # support clipboard on nvim
  home.packages = with pkgs; [
    icu
    wl-clipboard
  ];
}
