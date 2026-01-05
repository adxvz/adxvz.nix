{ pkgs, ... }:
{

  # imports = [ ./gnome-osk.nix ];

  options = { };

  config = {

    #services.xserver.desktopManager.xfce.enable = true;

    # Display manager settings
    services.displayManager.gdm = {
      enable = true;
      autoSuspend = true;
      wayland = true;
    };

    # This block is here to ensure we get GDM with the custom on screen keyboard extension
    # in the settings I want.
    programs.dconf.profiles.gdm.databases = [
      {
        #lockAll = false;
        settings."org/gnome/shell" = {
          enabled-extensions = [
            "${pkgs.gnomeExtensions.tray-icons-reloaded}"
            "${pkgs.gnomeExtensions.blur-my-shell}"
          ];
        };
      }

      {
        #lockAll = false;
        settings."org/gnome/desktop/a11y/applications" = {
          screen-keyboard-enabled = true;
        };
      }
    ];

    services.desktopManager.gnome.enable = true;

    services.gnome.core-apps.enable = false;
    services.gnome.core-utilities.enable = false;

    environment.gnome.excludePackages = with pkgs; [
      baobab # disk usage analyzer
      epiphany # web browser
      gedit # text editor
      simple-scan # document scanner
      totem # video player
      yelp # help viewer
      geary # email client
      seahorse # password manager
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-screenshot
      gnome-weather
      gnome-connections
      gnome-tour
      orca
      gnome.gnome-terminal
    ];

    # We also lose nautilus now though, so we add back stuff we actually care about...
    environment.systemPackages = with pkgs; [
      eog # image viewer
      evince # document viewer
      file-roller # archive manager
      gnome-system-monitor
      gnome-disk-utility
      nautilus
      xorg.xwininfo
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.blur-my-shell
    ];

    services.xserver.excludePackages = [ pkgs.xterm ];
  };
}
