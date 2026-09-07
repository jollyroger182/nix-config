# linux-only config
{ ... }:

{
  imports = [
    ./apps.nix
    ./packages.nix
    ./taut.nix
  ];
}
