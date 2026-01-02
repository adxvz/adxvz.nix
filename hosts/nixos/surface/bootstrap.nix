{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../common
  ];

  hardware.enableAllFirmware = true;

  environment.systemPackages = with pkgs; [
    zed-editor

  ];

}
