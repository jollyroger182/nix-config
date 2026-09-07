{ pkgs, ... }:

{
  users.users.jolly = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable 'sudo' for the user.
    packages = with pkgs; [
    ];
  };
}
