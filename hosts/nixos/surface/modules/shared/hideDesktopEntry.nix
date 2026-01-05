{ config, lib, pkgs, ... }: 

{
  documentation.nixos.enable = false;
  environment.systemPackages = with pkgs; [

    # Hide Neovim desktop entry
    (lib.hiPrio (pkgs.runCommand "nvim.desktop-hide" { } ''
      mkdir -p "$out/share/applications"
      cat "${config.programs.neovim.package}/share/applications/nvim.desktop" > "$out/share/applications/nvim.desktop"
      echo "Hidden=1" >> "$out/share/applications/nvim.desktop"
    ''))

    # Hide fish desktop entry
    (lib.hiPrio (pkgs.runCommand "fish.desktop-hide" { } ''
      mkdir -p "$out/share/applications"
      cat "${config.programs.fish.package}/share/applications/fish.desktop" > "$out/share/applications/fish.desktop"
      echo "Hidden=1" >> "$out/share/applications/fish.desktop"
    ''))

  ];
}
