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
    starship.enable = true;
    yazi.enable = true;

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
    #     ".config/jj/".source = ../bin/dots/jj;
    #     ".config/nvim/".source = ../bin/dots/nvim;
    #     ".config/nushell/".source = ../bin/dots/nushell;
    #     ".config/starship/".source = ../bin/dots/starship;
    #     ".config/yazi/".source = ../bin/dots/yazi;
    #   };

  };

  programs = {
    fzf.enable = true;

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

  };

}
