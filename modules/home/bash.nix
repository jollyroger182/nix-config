# common shell config; platform-specific things go in ./{darwin,linux}.nix
{ ... }:

{
  home.sessionVariables = {
    PYTHONDONTWRITEBYTECODE = 1;
    CEDEV = "$HOME/CEdev";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      py3 = "python3";
      ptest = "source ~/.venvs/test/bin/activate";
    };

    # login shells + interactive shells
    profileExtra = ''
      export PATH="$HOME/CEdev/bin:$PATH"
      export PATH="$PATH:$HOME/go/bin:$HOME/.yarn/bin:$HOME/.local/bin:$HOME/.bun/bin"
      export PATH="$PATH:/opt/oss-cad-suite/bin:/opt/xpack-riscv-none-elf-gcc-14.2.0-3/bin"

      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    '';

    # interactive shells only
    initExtra = ''
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
    '';
  };
}
