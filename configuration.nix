{ pkgs, self, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    nixd
    nixfmt

    aria2
    bun
    fd
    ffmpeg
    figlet
    gh
    git-lfs
    htop
    nmap
    tmux
    tree
    uv
    watch
  ];

  # Replaces the hand-written `direnv hook bash` line and pulls in nix-direnv.
  programs.direnv.enable = true;
  programs.direnv.silent = true;

  nix.settings = {
    # Necessary for using flakes on this system.
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "jolly"
    ];
  };

  system.primaryUser = "jolly";

  users.knownUsers = [ "jolly" ];

  users.users.jolly = {
    uid = 501;
    name = "jolly";
    description = "Jolly";
    home = "/Users/jolly";
    shell = pkgs.bashInteractive;
    isHidden = false;
  };

  # Add the Nix bash to /etc/shells so it is a permitted login shell.
  environment.shells = [ pkgs.bashInteractive ];

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  homebrew = {
    enable = true;

    onActivation = {
      # "none" - keep undeclared packages installed
      # "uninstall" - uninstall undeclared packages
      # "zap" - uninstall and delete data
      # "check" - throw on mismatch
      cleanup = "check";
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
      "openscad@snapshot"
      "raycast"
      "steamcmd"
    ];

    brews = [
      "automake"
      "bison"
      "cloudflared"
      "cmake"
      "cmake-docs"
      "coreutils"
      "docker-compose"
      "go"
      "grpcurl"
      "mdv"
      "mole"
      "mpv"
      "ninja"
      "node"
      "node@20"
      "ollama"
      "openjdk"
      "openjdk@21"
      "podman"
      "postgresql@17"
      "protobuf"
      "protolint"
      "rustup"
      "xcodegen"
      "xray"
    ];
  };

  programs.bash.completion.enable = true;
  programs.bash.interactiveShellInit = ''
    __nix_ps1() { [ -n "$IN_NIX_SHELL" ] && printf '(nix) '; }
    PS1='$(__nix_ps1)\[\e[38;5;213m\]\w\[\e[0m\] \[\e[38;5;245m\]❯\[\e[0m\] '

    export PYTHONDONTWRITEBYTECODE=1

    alias py3='python3'
    alias ptest='source ~/.venvs/test/bin/activate'
    alias rmquarantine='xattr -rd com.apple.quarantine'
    alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'

    # Homebrew
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
    fi

    # Language / tool prefixes
    export N_PREFIX="$HOME/.n"
    export CEDEV="$HOME/CEdev"
    export PATH="$HOME/.n/bin:$HOME/CEdev/bin:$PATH"
    export PATH="$PATH:$HOME/go/bin:$HOME/.yarn/bin:$HOME/.local/bin:$HOME/.bun/bin"
    export PATH="$PATH:/opt/oss-cad-suite/bin:/opt/xpack-riscv-none-elf-gcc-14.2.0-3/bin"

    # Rust
    [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

    # ngrok
    if command -v ngrok >/dev/null 2>&1; then
      eval "$(ngrok completion)"
    fi
  '';

  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 25;
      KeyRepeat = 2;

      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      AppleICUForce24HourTime = true;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleTemperatureUnit = "Celsius";
    };

    dock = {
      autohide = true;
      expose-group-apps = true;
      mineffect = "genie";
      tilesize = 64;

      # Hot corners: 2 = Mission Control, 10 = Put Display to Sleep,
      # 11 = Launchpad. The top-right corner is unset on this machine,
      # so it is left unmanaged.
      wvous-tl-corner = 2;
      wvous-bl-corner = 11;
      wvous-br-corner = 10;

      persistent-apps = [
        { app = "/System/Applications/Apps.app"; }
        { app = "/Applications/Zen.app"; }
        { app = "/System/Applications/Mail.app"; }
        { app = "/System/Applications/Photos.app"; }
        { app = "/System/Applications/Calendar.app"; }
        { app = "/System/Applications/Reminders.app"; }
        { app = "/Applications/WeChat.app"; }
        { app = "/Applications/Taut.app"; }
        { app = "/Applications/Visual Studio Code.app"; }
        { app = "/Applications/Xcode.app"; }
        { app = "/System/Applications/Utilities/Terminal.app"; }
        { app = "/System/Applications/Utilities/Activity Monitor.app"; }
        { app = "/Applications/Notability.app"; }
        { app = "/System/Applications/Shortcuts.app"; }
        { app = "/System/Applications/System Settings.app"; }
      ];

      persistent-others = [
        { folder = "/Users/jolly/Downloads"; }
        { folder = "/Users/jolly/Downloads/HC Memes"; }
        { folder = "/Users/jolly/Downloads/HC PFPs"; }
      ];
    };

    finder = {
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv"; # list view
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Home";
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
    };

    trackpad = {
      Clicking = false;
      TrackpadRightClick = true;
      TrackpadCornerSecondaryClick = 0;

      Dragging = false;
      DragLock = false;
      TrackpadThreeFingerDrag = false;

      ActuateDetents = true;
      ForceSuppressed = false;
      FirstClickThreshold = 1;
      SecondClickThreshold = 1;

      TrackpadMomentumScroll = true;
      TrackpadPinch = true;
      TrackpadRotate = true;
      TrackpadTwoFingerDoubleTapGesture = true;
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
      TrackpadThreeFingerTapGesture = 0;
      TrackpadThreeFingerHorizSwipeGesture = 2;
      TrackpadThreeFingerVertSwipeGesture = 2;
      TrackpadFourFingerHorizSwipeGesture = 2;
      TrackpadFourFingerVertSwipeGesture = 2;
      TrackpadFourFingerPinchGesture = 2;
    };

    magicmouse.MouseButtonMode = "OneButton";

    screencapture = {
      location = "~/Documents/Screenshots";
      target = "file";
    };

    menuExtraClock = {
      IsAnalog = false;
      ShowAMPM = false;
      ShowDate = 0; # 0 = when space allows
      ShowDayOfWeek = false;
    };

    WindowManager = {
      GloballyEnabled = false; # Stage Manager off
      AutoHide = false;
      AppWindowGroupingBehavior = true;
      HideDesktop = true;
      EnableTiledWindowMargins = false;
      StandardHideWidgets = false;
      StageManagerHideWidgets = false;
    };
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
