# global packages for all users; only put things you'd need under sudo
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];
}
