# macos-only config
{ ... }:

{
  imports = [
    ./bash.nix
    ./packages.nix
    ./sync-tokens.nix
  ];
}
