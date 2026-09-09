# per-user packages
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nixfmt

    aria2
    automake
    bison
    bun
    cloudflared
    cmakeCurses
    docker-compose
    fd
    ffmpeg
    figlet
    grpcurl
    htop
    ninja
    nmap
    protobuf
    protolint
    ripgrep
    tmux
    tree
  ];
}
