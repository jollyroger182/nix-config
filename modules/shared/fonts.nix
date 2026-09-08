{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
  ];
}
