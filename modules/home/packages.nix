# per-user packages
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nixfmt

    # anki
    aria2
    cloudflared
    cmakeCurses
    docker-compose
    ffmpeg
    htop
    mpv
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
  };
}
