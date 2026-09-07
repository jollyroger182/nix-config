{ ... }:

{
  # User-level config. Things that belong to *you* rather than the machine:
  # prompt, aliases, PATH, per-tool setup.
  home.stateVersion = "26.11";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    sessionVariables = {
      PYTHONDONTWRITEBYTECODE = 1;
    };

    shellAliases = {
      py3 = "python3";
      ptest = "source ~/.venvs/test/bin/activate";
      rmquarantine = "xattr -rd com.apple.quarantine";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };

    initExtra = ''
      # Mimic zsh's PROMPT_SP: if a command's output did not end in a newline,
      # mark the truncation with a reverse-video % and start the prompt on a
      # fresh line instead of overwriting the partial output. Writing exactly
      # $COLUMNS cells wraps only when the cursor was mid-line; the trailing \r
      # then puts us at column 0 either way.
      __prompt_eol() {
        local w=$COLUMNS
        [ -n "$w" ] || w=80
        printf '\033[7m%%\033[0m%*s\r' "$(( w - 1 ))" ""
      }
      if [[ "$(declare -p PROMPT_COMMAND 2>&1)" == "declare -a"* ]]; then
        PROMPT_COMMAND+=(__prompt_eol)
      else
        PROMPT_COMMAND="$PROMPT_COMMAND"$'\n'"__prompt_eol"
      fi

      __nix_ps1() { [ -n "$IN_NIX_SHELL" ] && printf '(nix) '; }
      PS1='$(__nix_ps1)\[\e[38;5;213m\]\w\[\e[0m\] \[\e[38;5;245m\]❯\[\e[0m\] '

      # Homebrew
      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
      fi

      # Language / tool prefixes
      export CEDEV="$HOME/CEdev"
      export PATH="$HOME/CEdev/bin:$PATH"
      export PATH="$PATH:$HOME/go/bin:$HOME/.yarn/bin:$HOME/.local/bin:$HOME/.bun/bin"
      export PATH="$PATH:/opt/oss-cad-suite/bin:/opt/xpack-riscv-none-elf-gcc-14.2.0-3/bin"

      # Rust
      [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

      # ngrok
      if command -v ngrok >/dev/null 2>&1; then
        eval "$(ngrok completion)"
      fi
    '';
  };
}
