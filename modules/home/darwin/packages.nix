# macos-only packages
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xcodegen

    # linux gets these from the base system
    watch
    coreutils-prefixed

    # expose coreutils commands with no bsd-equivalent unprefixed
    (runCommand "coreutils-gnu-only" { } ''
      mkdir -p $out/bin
      for f in b2sum base32 basenc factor hostid nproc numfmt pinky ptx \
               shred shuf tac timeout; do
        ln -s ${coreutils}/bin/$f $out/bin/$f
      done
    '')
  ];
}
