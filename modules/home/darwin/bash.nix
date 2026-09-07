# macos shell config
{ lib, ... }:

{
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
