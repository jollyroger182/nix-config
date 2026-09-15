# macos shell config
{ lib, ... }:

{
  # bsd ls/grep are colorless by default; nixos already does this on linux
  home.sessionVariables = {
    CLICOLOR = 1;

    # fg/bg pair per type, in order: dir, symlink, socket, pipe, exec, block,
    # char, setuid exec, setgid exec, sticky other-writable dir, other-writable
    # dir. lowercase = normal, uppercase = bold, x = terminal default.
    LSCOLORS = "ExGxFxdxCxDxDxhbadacad";
  };

  programs.bash = {
    shellAliases = {
      rmquarantine = "xattr -rd com.apple.quarantine";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";

      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
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
