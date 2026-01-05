{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 3d";
    };
    flake = "/home/adxvz/Downloads/NixOS/SurfaceNix/";
  };
}
