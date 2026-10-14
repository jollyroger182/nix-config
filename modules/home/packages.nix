# per-user packages
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nixfmt

    aria2
    cmakeCurses
    docker-compose
    ffmpeg
    htop
    nmap
    protobuf
    protolint
    ripgrep
    tmux
    tree
  ];

  programs.claude-code.enable = true;

  programs.bun = {
    enable = true;
    enableGitIntegration = true;

    # bun's bash completion matches against the never-defined
    # $re_comp_word_script; macOS regcomp rejects the empty regex and prints
    # "invalid regular expression" on every tab
    package = pkgs.bun.overrideAttrs (old: {
      postPatchelf = old.postPatchelf + ''
        substituteInPlace $out/share/bash-completion/completions/bun.bash \
          --replace-fail '( "''${COMPREPLY[*]}" =~ ''${re_comp_word_script} )' \
                         '( -n "''${re_comp_word_script}" && "''${COMPREPLY[*]}" =~ ''${re_comp_word_script} )'
      '';
    });
  };

  programs.npm = {
    enable = true;
    package = pkgs.nodejs_24;
  };
}
