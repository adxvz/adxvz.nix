{
  pkgs,
  ...
}:

{

  imports = [
    ./bootstrap.nix
    ./settings.nix
    ../../shared
  ];

  modules.nix.enable = true;

  launchd.daemons.tuptime = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path ${pkgs.tuptime} && /etc/tuptimed.sh"
      ];
      RunAtLoad = true;
      StandardOutPath = "/var/log/tuptime/stdout";
      StandardErrorPath = "/var/log/tuptime/stderr";
    };
  };
}
