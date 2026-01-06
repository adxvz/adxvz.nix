{ ... }:
{
  imports = [
    ./bootstrap.nix
    ./settings.nix
    ../../common/pkgs.nix
  ];

  nixpkgs.config.allowUnfree = true;

}
