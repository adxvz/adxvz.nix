{ vars, ... }:

{

  networking = {
    computerName = "${vars.m1max}";
    hostName = "${vars.m1max}";
    localHostName = "${vars.m1max}";
  };

  security = {
    pam.services.sudo_local = {
      enable = true;
      touchIdAuth = true;
      reattach = true;
    };
  };

  system = {
    primaryUser = "${vars.primaryUser}";
    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };
      NSGlobalDomain = {
        # macOS applies something called "font smoothing" (image) which is adding a layer of pixels to your text. The effect is that text is made a little more bold. Options are 0, 1, or 2
        # AppleFontSmoothing = 2;
        # Whether to use 24-hour or 12-hour time. The default is based on region settings.
        AppleICUForce24HourTime = true;
        # Set to ‘Dark’ to enable dark mode, or leave unset for normal mode.
        # AppleInterfaceStyle = " ";
        # Whether to automatically switch between light and dark mode.
        AppleInterfaceStyleSwitchesAutomatically = false;
        # Whether to use centimeters (metric) or inches (US, UK) as the measurement unit.
        AppleMeasurementUnits = "Inches";
        # Whether to use the metric system. The default is based on region settings.
        AppleMetricUnits = 0;
        # Jump to the spot that’s clicked on the scroll bar.
        AppleScrollerPagingBehavior = true;
        # Whether to show all file extensions in Finder.
        AppleShowAllExtensions = true;
        # Whether to always show hidden files.
        AppleShowAllFiles = true;
        # When to show the scrollbars. Options are ‘WhenScrolling’, ‘Automatic’ and ‘Always’.
        AppleShowScrollBars = "WhenScrolling";
        # Whether to use Celsius or Fahrenheit.
        AppleTemperatureUnit = "Celsius";
        # This sets how long you must hold down the key before it starts repeating. Options are: 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;
        # This sets how fast a key repeats, once started. Options are: 120, 90, 60, 30, 12, 6, 2, 1
        KeyRepeat = 1;
        # Whether to enable automatic capitalization.
        NSAutomaticCapitalizationEnabled = false;
        # Whether to enable smart dash substitution.
        NSAutomaticDashSubstitutionEnabled = false;
        # Whether to enable smart period substitution.
        NSAutomaticPeriodSubstitutionEnabled = false;
        # Whether to enable smart quote substitution.
        NSAutomaticQuoteSubstitutionEnabled = false;
        # Whether to enable automatic spelling correction.
        NSAutomaticSpellingCorrectionEnabled = false;
        # Whether to animate opening and closing of windows and popovers.
        NSAutomaticWindowAnimationsEnabled = false;
        # Whether to disable the automatic termination of inactive apps.
        NSDisableAutomaticTermination = true;
        # Whether to save new documents to iCloud by default.
        NSDocumentSaveNewDocumentsToCloud = true;
        # Whether to use expanded save panel by default.
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        # Sets the size of the finder sidebar icons: 1 (small), 2 (medium) or 3 (large). The default is 3.
        NSTableViewDefaultSizeMode = 2;
        # Whether to enable moving window by holding anywhere on it like on Linux.
        NSWindowShouldDragOnGesture = true;
        # Whether to use the expanded print panel by default.
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
        # Configures the trackpad tap behavior. Mode 1 enables tap to click.
        "com.apple.mouse.tapBehavior" = 1;
        # Make a feedback sound when the system volume changed.
        "com.apple.sound.beep.feedback" = 0;
        # Sets the beep/alert volume level from 0.000 (muted) to 1.000 (100% volume).
        "com.apple.sound.beep.volume" = 0.0;
        # Configures the trackpad corner click behavior. Mode 1 enables right click.
        "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
      };
      SoftwareUpdate = {
        # Automatically install Mac OS software updates. well duh!
        AutomaticallyInstallMacOSUpdates = true;
      };
      WindowManager = {
        # Grouping strategy when showing windows from an application. false means “One at a time” true means “All at once”
        AppWindowGroupingBehavior = true;
        # Auto hide stage strip showing recent apps.
        AutoHide = true;
        # Click wallpaper to reveal desktop Clicking your wallpaper will move all windows out of the way to allow access to your desktop items and widgets. false means “Only in Stage Manager” true means “Always”
        EnableStandardClickToShowDesktop = false;
      };
      dock = {
        # Whether to automatically hide and show the dock
        autohide = true;
        # Sets the speed of the autohide delay.
        autohide-delay = 10000.00;
        # Position of the dock on screen. The default is “bottom”.
        orientation = "bottom";
        # Persistent applications in the dock.
        persistent-apps = [ ];
        # Show recent applications in the dock.
        show-recents = false;
        # Show only open applications in the Dock.
        static-only = true;
        # Size of the icons in the dock.
        tilesize = 12;
        # disable hot corners
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      finder = {
        # Whether to always show file extensions.
        AppleShowAllExtensions = true;
        # Whether to always show hidden files.
        AppleShowAllFiles = true;
        # Change the default search scope. `SCcf` is for the current folder, `SCev` is for the Mac & `SCsp` is for previous scope.
        FXDefaultSearchScope = "SCcf";
        # Whether to show warnings when change the file extension of files.
        FXEnableExtensionChangeWarning = false;
        # Set preferred view style.  Icon View   : `icnv` / List View   : `Nlsv` / Column View : `clmv` / Cover Flow  : `Flwv`
        FXPreferredViewStyle = "Nlsv";
        # Whether to allow quitting of the Finder.
        QuitMenuItem = true;
        # Show path breadcrumbs in finder windows.
        ShowPathbar = true;
        # Show status bar at bottom of finder windows with item/disk space stats.
        ShowStatusBar = true;
        # Whether to show the full POSIX filepath in the window title.
        _FXShowPosixPathInTitle = false;
        # Keep folders on top when sorting by name.
        _FXSortFoldersFirst = true;
      };
      loginwindow = {
        # Allow users to login to the machine as guests using the Guest account.
        GuestEnabled = false;
        # Text to be shown on the login window.
        LoginwindowText = ":: adxvz ::";
      };
      menuExtraClock = {
        # Show an analog clock instead of a digital one.
        IsAnalog = false;
        # Show a 24-hour clock, instead of a 12-hour clock.
        Show24Hour = true;
        # Show the AM/PM label. Useful if Show24Hour is false.
        ShowAMPM = false;
        # Show the full date. 0 = When space allows 1 = Always 2 = Never
        ShowDate = 2;
        ShowDayOfMonth = false;
        ShowDayOfWeek = false;
        #Show the clock with second precision, instead of minutes.
        ShowSeconds = false;
      };
      screensaver = {
        # If true, the user is prompted for a password when the screen saver is unlocked or stopped.
        askForPassword = true;
        # The number of seconds to delay before the password will be required to unlock or stop the screen saver (the grace period).
        askForPasswordDelay = 300;
      };
      trackpad = {
        # Whether to enable trackpad tap to click. The default is false.
        Clicking = true;
        # Whether to enable trackpad right click.
        TrackpadRightClick = true;
        # Whether to enable three finger drag.
        TrackpadThreeFingerDrag = true;
      };

    };
    keyboard = {
      # Whether to enable keyboard mappings.
      enableKeyMapping = true;
    };
  };

}
