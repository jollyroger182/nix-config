{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      # "none" - keep undeclared packages installed
      # "uninstall" - uninstall undeclared packages
      # "zap" - uninstall and delete data
      # "check" - throw on mismatch
      cleanup = "uninstall";
      autoUpdate = false;
      upgrade = false;
    };

    casks = [
      "alt-tab"
      "android-commandlinetools"
      "android-platform-tools"
      "anki"
      "claude-code"
      "discord"
      "docker-desktop"
      "openscad@snapshot"
      "raycast"
      "steamcmd"
    ];

    brews = [
      "go"
      "mdv"
      "mole"
      "mpv"
      "node"
      "ollama"
      "openjdk@21"
      "podman"
      "postgresql@17"
      "rustup"
      "xray"
    ];
  };
}
