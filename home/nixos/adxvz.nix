{ config, pkgs, ... }:
{

  imports = [
  ];

  options = { };

  config = {

    # Surface related stuff.
    services.iptsd.enable = true;

    sound.enable = true;

    hardware.pulseaudio.enable = false;

    # https://discourse.nixos.org/t/bluetooth-a2dp-sink-not-showing-up-in-pulseaudio-on-nixos/32447/3
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # https://github.com/NixOS/nixpkgs/blob/4ecab3273592f27479a583fb6d975d4aba3486fe/nixos/modules/services/x11/desktop-managers/gnome.nix#L459

    # Configure keymap in X11
    services.xserver.layout = "gb";
    # services.xserver.xkbOptions = "eurosign:e,caps:escape";
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.autoSuspend = false;

    # This block is here to ensure we get GDM with the custom on screen keyboard extension
    # in the settings I want.
    programs.dconf.profiles.gdm.databases = [
      {
        #lockAll = false;
        settings."org/gnome/shell/extensions/enhancedosk" = {
          show-statusbar-icon = true;
          locked = true;
        };
      }

      {
        #lockAll = false;
        settings."org/gnome/shell" = {
          enabled-extensions = [ "iwanders-gnome-enhanced-osk-extension" ];
        };
      }

      {
        #lockAll = false;
        settings."org/gnome/desktop/a11y/applications" = {
          screen-keyboard-enabled = true;
        };
      }
    ];

    services.xserver.desktopManager.gnome.enable = true;

    services.gnome.core-utilities.enable = false;

    services.usbmuxd.enable = true; # For mounting ios devices.

  };
}
