# linux-only config
{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  # support clipboard on nvim
  home.packages = [ pkgs.wl-clipboard ];

  # managed by homebrew on mac; delete casks when migrating to shared config
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
  };

  programs.firefox.enable = true;

  programs.claude-code.enable = true;
}
