# macos-only config
{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.packages = with pkgs; [
    # linux gets these from the base system
    watch
    coreutils-prefixed
    xcodegen

    # expose coreutils commands with no bsd-equivalent unprefixed
    (runCommand "coreutils-gnu-only" { } ''
      mkdir -p $out/bin
      for f in b2sum base32 basenc factor hostid nproc numfmt pinky ptx \
               shred shuf tac timeout; do
        ln -s ${coreutils}/bin/$f $out/bin/$f
      done
    '')
  ];

  programs.bash = {
    shellAliases = {
      rmquarantine = "xattr -rd com.apple.quarantine";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };

    # have nix win over homebrew (`brew shellenv` prepends to PATH)
    profileExtra = lib.mkAfter ''
      if [ -x /opt/homebrew/bin/brew ]; then
        export HOMEBREW_PREFIX=/opt/homebrew
        export HOMEBREW_CELLAR=/opt/homebrew/Cellar
        export HOMEBREW_REPOSITORY=/opt/homebrew
        export MANPATH="/opt/homebrew/share/man:$MANPATH"
        export INFOPATH="/opt/homebrew/share/info:$INFOPATH"
        export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin"
        export PATH="$PATH:/opt/homebrew/opt/postgresql@17/bin"
      fi
    '';
  };
}
