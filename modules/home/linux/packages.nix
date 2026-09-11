# linux-only packages
{ pkgs, ... }:

{
  # support clipboard on nvim
  home.packages = with pkgs; [
    (olympus.override { celesteWrapper = "steam-run"; })
    wl-clipboard
  ];
}
