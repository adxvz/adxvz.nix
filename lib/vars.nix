{
  self,
  inputs,
}:

let
  lib = inputs.nixpkgs.lib;

  vars = {
    currentSystem = "aarch64-darwin";
    primaryUser = "adxvz";
    primaryEmail = "adam@coopr.network";
    m1max = "m1max";
    surface = "surface";
    ks1 = "do";
    ks2 = "re";
    ks3 = "mi";
    ks4 = "fa";
    ks5 = "so";
    ks6 = "la";
    ks7 = "ti";
  };

  versions = {
    darwin.stateVersion = 6;
    homeManager.stateVersion = "26.05";
    nixos.stateVersion = "26.05";
    nixos.stableVersion = "25.11";
    rev = self.rev or self.dirtyRev or "dirty";
  };
in
{
  inherit vars versions lib;
}
