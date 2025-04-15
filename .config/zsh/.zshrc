# Download zinit
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# Source aliases and options for zsh
[ -f "${ZDOTDIR}/aliasrc" ] && source "${ZDOTDIR}/aliasrc"
[ -f "${ZDOTDIR}/optionrc" ] && source "${ZDOTDIR}/optionrc"

# PATH
# export PATH=$PATH:/usr/local/go/bin
# export PATH=$PATH:$HOME/.local/kitty.app/bin
# export PATH=$PATH:$HOME/.local/share/bob/nvim-bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.cargo/bin
# export PATH=$PATH:$HOME/.fzf/bin

# Load completion
autoload -U compinit && compinit
zinit cdreplay -q

# Plugins
zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light hlissner/zsh-autopair
zinit light zap-zsh/exa

# Snippets
zinit snippet OMZP::sudo

# Exports
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export TERMINAL="kitty"
export BROWSER="librewolf"
export EDITOR="nvim"
export VISUAL="nvim"

# NPM and Ruby version managers
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
SAVEHIST=$HISTSIZE
HISTFILE=$XDG_CACHE_HOME/.zsh_history
HISTDUP=erase

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/melon.toml)"
eval "$(fzf --zsh)"
