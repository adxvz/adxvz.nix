{
  config,
  lib,
  pkgs,
  ...
}:

{
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.thermald.enable = true;

  services.upower.enable = true;

  # Better tablet behavior
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";
  };

  environment.systemPackages = with pkgs; [
    surface-control
  ];
}
