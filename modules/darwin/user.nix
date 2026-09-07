{ pkgs, ... }:

{
  system.primaryUser = "jolly";

  users.knownUsers = [ "jolly" ];

  users.users.jolly = {
    uid = 501;
    name = "jolly";
    description = "Jolly";
    home = "/Users/jolly";
    shell = pkgs.bashInteractive;
    isHidden = false;
  };

  # Add the Nix bash to /etc/shells so it is a permitted login shell.
  environment.shells = [ pkgs.bashInteractive ];
}
