# macos system preferences
{ ... }:

{
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
      # 11 = Launchpad.
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
        {
          folder = {
            arrangement = "date-added";
            path = "/Users/jolly/Downloads";
            showas = "fan";
          };
        }
        {
          folder = {
            arrangement = "date-added";
            path = "/Users/jolly/Downloads/HC Memes";
            showas = "fan";
          };
        }
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
}
