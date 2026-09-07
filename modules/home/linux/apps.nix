# gui apps; managed by homebrew on mac, delete casks when migrating to shared
{ ... }:

{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
  };

  programs.firefox.enable = true;

  programs.claude-code.enable = true;
}
