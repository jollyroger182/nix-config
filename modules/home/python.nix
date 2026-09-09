{ pkgs, ... }:

{
  programs.uv = {
    enable = true;
    settings = {
      # python-downloads = "never";
    };
    python = {
      default = [ "3.14" ];
      versions = [
        "3.14"
        "pypy@3.11"
      ];
    };
  };

  home.packages = with pkgs; [
    python314
  ];
}
