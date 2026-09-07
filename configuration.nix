{ pkgs, self, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    nixd
    nixfmt
  ];

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

  # macOS defaults, captured from this machine's live state.
  # Only keys that were actually set are declared; anything omitted stays
  # unmanaged rather than being silently reset to Apple's default.
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
