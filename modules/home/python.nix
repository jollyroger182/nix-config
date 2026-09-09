{ ... }:

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
        "2.7"
        "pypy@3.11"
      ];
    };
  };
}
