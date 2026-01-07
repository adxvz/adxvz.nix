{ pkgs,... }:

{

programs.tmux = {
  enable = true;
  sensibleOnTop = false;
  terminal = "tmux-256color";
  historyLimit = 100000;
  extraConfig = builtins.readFile ./tmux.conf;

  plugins = with pkgs; [
    tmuxPlugins.cpu
    tmuxPlugins.yank
    tmuxPlugins.tmux-thumbs
    tmuxPlugins.tmux-fzf
    tmuxPlugins.fzf-tmux-url
    tmuxPlugins.session-wizard
    tmuxPlugins.tmux-floax
    tmuxPlugins.resurrect
    tmuxPlugins.continuum
     ];
  };
}
