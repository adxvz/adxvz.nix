{
  pkgs,
  inputs,
  ...
}:

{
  modules = {
    atuin.enable = true;
    bat.enable = true;
    fastfetch.enable = true;

    git = {
      enable = true;
      useLatestGit = true;
      githubCli = true;
      installTools = true;
    };
    ssh.enable = true;
    jujutsu = {
      enable = true;
      useLatest = true;
      userName = "Adam Cooper";
      userEmail = "adam@coopr.network";
    };
    emacs = {
      enable = true;
      config = true;
      enableOrg = true;
      enableDenote = true;
      enableCitar = true;
      enableMultimedia = true;
    };
    nushell.enable = true;
    zsh.enable = true;
    fish.enable = true;
  };

  home = {

    packages = with pkgs; [
      direnv
    ];

    #   file = {
    #     ".config/atuin/".source = ../bin/dots/atuin;
    #     ".config/bat/".source = ../bin/dots/bat;
    #     ".config/emacs/".source = ../bin/dots/emacs;
    #     ".config/fastfetch".source = ../bin/dots/fastfetch;
    #     ".config/ghostty/".source = ../bin/dots/ghostty;
    #     ".config/jj/".source = ../bin/dots/jj;
    #     ".config/nvim/".source = ../bin/dots/nvim;
    #     ".config/nushell/".source = ../bin/dots/nushell;
    #     ".config/starship/".source = ../bin/dots/starship;
    #     ".config/yazi/".source = ../bin/dots/yazi;
    #   };

  };

  programs = {
    fzf.enable = true;

    starship = {
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

}
