{

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "adxvz" ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    # overlays = [ (import ./gnome/overlay-osk.nix) ];
  };

}
