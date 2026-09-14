{ ... }:

{
  programs.mpv = {
    enable = true;
    bindings = {
      "Ctrl++" = "add audio-delay 0.025";
      "Ctrl+-" = "add audio-delay -0.025";
    };
  };
}
