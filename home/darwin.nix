{ ... }:

{

  targets.darwin.linkApps.enable = false;

  home.file = {
    ".config/atuin/".source = ../bin/dots/atuin;
    ".config/bat/".source = ../bin/dots/bat;
    ".config/doom/".source = ../bin/dots/doom;
    ".config/fastfetch".source = ../bin/dots/fastfetch;
    ".config/ghostty/".source = ../bin/dots/ghostty;
    ".config/jj/".source = ../bin/dots/jj;
    ".config/nvim/".source = ../bin/dots/nvim;
    ".config/nushell/".source = ../bin/dots/nushell;
    ".config/starship/".source = ../bin/dots/starship;
    ".config/yazi/".source = ../bin/dots/yazi;
  };

  modules = {
    git.enable = true;
    emacs = {
      enable = true;
      org.enable = true;
      doom.enable = false;
    };
  };

}
