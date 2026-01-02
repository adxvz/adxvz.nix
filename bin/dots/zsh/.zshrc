typeset -U path cdpath fpath manpath
for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

HELPDIR="/nix/store/2g3h900iy7ri455lyjycpmjx6fw8pgi4-zsh-5.9/share/zsh/$ZSH_VERSION/help"

# Use viins keymap as the default.
bindkey -v

# Add plugin directories to PATH and fpath
plugin_dirs=(
  zsh-abbr zsh-vi-mode zsh-completions fzf-tab zsh-autosuggestions
  zsh-syntax-highlighting nix-zsh-completions
)
for plugin_dir in "${plugin_dirs[@]}"; do
  path+="/Users/adxvz/.zsh/plugins/$plugin_dir"
  fpath+="/Users/adxvz/.zsh/plugins/$plugin_dir"
done
unset plugin_dir plugin_dirs


autoload -U compinit && compinit
source /nix/store/zsd47jhcyvpqk20w67j9i85wxgnq4bq4-zsh-autosuggestions-0.7.1/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history)


# Source plugins
plugins=(
  zsh-abbr/share/zsh/zsh-abbr/zsh-abbr.plugin.zsh
  zsh-vi-mode/zsh-vi-mode.plugin.zsh zsh-completions/zsh-completions.plugin.zsh
  fzf-tab/fzf-tab.plugin.zsh zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
  zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
  nix-zsh-completions/nix-zsh-completions.plugin.zsh
)
for plugin in "${plugins[@]}"; do
  [[ -f "/Users/adxvz/.zsh/plugins/$plugin" ]] && source "/Users/adxvz/.zsh/plugins/$plugin"
done
unset plugin plugins

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.config/zsh/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK

# Enabled history options
enabled_opts=(
  EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS
  HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS SHARE_HISTORY autocd
)
for opt in "${enabled_opts[@]}"; do
  setopt "$opt"
done
unset opt enabled_opts

# Disabled history options
disabled_opts=(
  APPEND_HISTORY
)
for opt in "${disabled_opts[@]}"; do
  unsetopt "$opt"
done
unset opt disabled_opts

if [[ $options[zle] = on ]]; then
  source <(/nix/store/mpfsr20cza2wskq0c4lcmh198667ga0w-fzf-0.66.0/bin/fzf --zsh)
fi

# Set shell options
set_opts=(
  INC_APPEND_HISTORY HIST_REDUCE_BLANKS
)
for opt in "${set_opts[@]}"; do
  setopt "$opt"
done
unset opt set_opts


fastfetch

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix


if [[ $TERM != "dumb" ]]; then
  eval "$(/nix/store/fh9p78na4ll0ijfviw1q14vhlq3ikv9c-starship-1.23.0/bin/starship init zsh)"
fi

if [[ $options[zle] = on ]]; then
  eval "$(/nix/store/4amf2iq54jfn3pnwm6li47sa96v8nps0-atuin-18.8.0/bin/atuin init zsh )"
fi

alias -- vimdiff='nvim -d'
source /nix/store/6k585kdgam2gq2plmv5ishkapd80gsq6-zsh-syntax-highlighting-0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()
