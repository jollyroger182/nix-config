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
      "discord"
      "docker-desktop"
      "openscad@snapshot"
      "raycast"
      "steamcmd"
    ];

    brews = [
      "openjdk@21"
      "postgresql@17"
    ];
  };
}
