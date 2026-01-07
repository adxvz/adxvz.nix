{ ... }:

{

  targets.darwin.linkApps.enable = false;

  home.file = {

    ".config/ghostty/".source = ../modules/home/terminals/ghostty/config;

  };

}
