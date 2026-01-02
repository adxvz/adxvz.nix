{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:

{

  modules = {

    ssh = {
      enable = true;
      keyDir = ../../bin/ssh;
      # keyRepo = "git@github.com:adxvz/sshkeys.git";
    };
    gpg = {
      enable = true;
      keyDir = ../../bin/gpg;
      # keyRepo = "git@github.com:adxvz/sshkeys.git";
    };

    git = {
      enable = true;
      useLatest = true;
      userName = "vars.primaryUser";
      userEmail = "vars.primaryEmail";
      gpgSign = {
        enable = false;
        #  key = "C6F213570EE66A35";
      };
      githubCli = true;
    };

    jujutsu = {
      enable = true;
      useLatest = true;
      userName = "vars.primaryUser";
      userEmail = "vars.primaryEmail";
      # extraConfig = '' ''
    };
    nushell.enable = true;
    zsh.enable = true;
    fish.enable = true;
    emacs = {
      enable = true;
      doom.enable = true;
      org.enable = true;
    };
  };

  home = {
    packages = with pkgs; [
      direnv
      lazygit
    ];

    file = {
      ".config/atuin/".source = ../../bin/dots/atuin;
      ".config/bat/".source = ../../bin/dots/bat;
      ".config/doom/".source = ../../bin/dots/doom;
      ".config/fastfetch".source = ../../bin/dots/fastfetch;
      ".config/ghostty/".source = ../../bin/dots/ghostty;
      ".config/jj/".source = ../../bin/dots/jj;
      ".config/nvim/".source = ../../bin/dots/nvim;
      ".config/nushell/".source = ../../bin/dots/nushell;
      ".config/starship/".source = ../../bin/dots/starship;
      ".config/yazi/".source = ../../bin/dots/yazi;
    };

  };

  programs.fastfetch.enable = true;

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.yazi = {
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
    settings = {
      log = {
        enabled = false;
      };
      manager = {
        show_hidden = true;
        sort_by = "modified";
        sort_dir_first = true;
        sort_reverse = true;
      };
    };
  };

  programs.zoxide = {
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batwatch
    ];
  };

  programs.fzf.enable = true;

  targets.darwin.linkApps.enable = false;
}
