{
  pkgs,
  inputs,
  ...
}:

{
  home = {

    packages = with pkgs; [
      direnv
      lazygit
    ];

  };

  programs = {
    fastfetch.enable = true;
    fzf.enable = true;

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batwatch
      ];
    };

    yazi = {
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_by = "modified";
          sort_dir_first = true;
          sort_reverse = true;
        };
      };
    };
  };

  modules = {
    git = {
      enable = true;
      useLatest = true;
      githubCli = true;
    };
    ssh.enable = true;
    jujutsu = {
      enable = true;
      useLatest = true;
      userName = "Adam Cooper";
      userEmail = "adam@coopr.network";
    };

    nushell.enable = true;
    zsh.enable = true;
    fish.enable = true;
  };

}
