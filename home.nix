{
  pkgs,
  self,
  hostName,
  ...
}:

{
  # User-level config. Things that belong to *you* rather than the machine:
  # prompt, aliases, PATH, per-tool setup.
  home.stateVersion = "26.11";

  home.sessionVariables = {
    PYTHONDONTWRITEBYTECODE = 1;
    CEDEV = "$HOME/CEdev";
  };

  home.packages = with pkgs; [
    nixd
    nixfmt

    aria2
    bun
    fd
    ffmpeg
    figlet
    gh
    htop
    nmap
    tmux
    tree
    uv
    watch
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      py3 = "python3";
      ptest = "source ~/.venvs/test/bin/activate";
      rmquarantine = "xattr -rd com.apple.quarantine";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };

    # Read by login shells, so scripts, ssh commands and GUI-launched
    # processes get the same PATH as an interactive terminal.
    profileExtra = ''
      export PATH="$HOME/CEdev/bin:$PATH"
      export PATH="$PATH:$HOME/go/bin:$HOME/.yarn/bin:$HOME/.local/bin:$HOME/.bun/bin"
      export PATH="$PATH:/opt/oss-cad-suite/bin:/opt/xpack-riscv-none-elf-gcc-14.2.0-3/bin"

      # Homebrew, appended *after* the Nix profiles rather than prepended as
      # `brew shellenv` does, so Nix wins name collisions. Today the overlap
      # is exactly ffmpeg/ffplay/ffprobe.
      if [ -x /opt/homebrew/bin/brew ]; then
        export HOMEBREW_PREFIX=/opt/homebrew
        export HOMEBREW_CELLAR=/opt/homebrew/Cellar
        export HOMEBREW_REPOSITORY=/opt/homebrew
        export MANPATH="/opt/homebrew/share/man:$MANPATH"
        export INFOPATH="/opt/homebrew/share/info:$INFOPATH"
        export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin"
        export PATH="$PATH:/opt/homebrew/opt/postgresql@17/bin"
      fi

      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    '';

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

      # ngrok
      if command -v ngrok >/dev/null 2>&1; then
        eval "$(ngrok completion)"
      fi
    '';
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user.name = "jollyroger182";
      user.email = "hello@jollyy.dev";
      pull.rebase = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      set clipboard=unnamedplus
      set number relativenumber
      set expandtab tabstop=2 shiftwidth=2
      set ignorecase smartcase
      set scrolloff=5
      set undofile
      set mouse=a

      nnoremap <Esc><Esc> :nohlsearch<CR>
    '';

    initLua = ''
      vim.lsp.config("nixd", {
        cmd = { "${pkgs.nixd}/bin/nixd" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },
        settings = {
          nixd = {
            nixpkgs = { expr = "import ${self.inputs.nixpkgs} { }" },
            formatting = { command = { "${pkgs.nixfmt}/bin/nixfmt" } },
            options = {
              ["nix-darwin"] = { expr = "(builtins.getFlake \"${self}\").darwinConfigurations.${hostName}.options" },
              ["home-manager"] = { expr = "(builtins.getFlake \"${self}\").darwinConfigurations.${hostName}.options.home-manager.users.type.getSubOptions []" }
            },
          },
        },
      })
      vim.lsp.enable("nixd")

      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "LSP format" })
    '';
  };
}
