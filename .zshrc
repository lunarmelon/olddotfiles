export ZDOTDIR="$HOME/.config/zsh"
export ZSHRC="$HOME/.zshrc"

[ -f "${ZDOTDIR}/aliasrc" ] && source "${ZDOTDIR}/aliasrc"
[ -f "${ZDOTDIR}/optionrc" ] && source "${ZDOTDIR}/optionrc"

# Plugins
source "${ZDOTDIR}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "${ZDOTDIR}/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
source "${ZDOTDIR}/plugins/zsh-autopair/autopair.zsh"
source "${ZDOTDIR}/plugins/supercharge/supercharge.plugin.zsh"
source "${ZDOTDIR}/plugins/exa/eza.plugin.zsh"
source "${ZDOTDIR}/plugins/sudo/sudo.plugin.zsh"

# Exports
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export TERMINAL="kitty"
export BROWSER="librewolf"
export EDITOR="nvim"
export VISUAL="nvim"

export PATH=$PATH:/home/melon/.local/kitty.app/bin
export PATH=$PATH:/home/melon/.spicetify
export PATH=$PATH:/home/melon/.cargo/bin
export PATH=$PATH:/home/melon/.local/share/bob/nvim-bin
export PATH=$PATH:/usr/local/go/bin

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Substring search keybinds
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[0A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[0B' history-substring-search-down

# History
HISTSIZE=110000
SAVEHIST=100000
HISTFILE=~/.cache/.zsh_history

# Completion
zstyle :compinstall ~/.config/zsh/.zshrc

autoload -Uz compinit
compinit

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/melon.toml)"
