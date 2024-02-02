# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config//zsh//.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f "${ZDOTDIR}/aliasrc" ] && source "${ZDOTDIR}/aliasrc"
[ -f "${ZDOTDIR}/optionrc" ] && source "${ZDOTDIR}/optionrc"
[ -f "${ZDOTDIR}/exportsrc" ] && source "${ZDOTDIR}/exportsrc"

# Plugins
source "${ZDOTDIR}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "${ZDOTDIR}/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"

# Substring search keybinds
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[0A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[0B' history-substring-search-down

# History
HISTSIZE=11000
SAVEHIST=10000
HISTFILE=~/.cache/.zsh_history

# Completion
zstyle :compinstall ~/.config/zsh/.zshrc

autoload -Uz compinit
compinit

source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config//zsh//.p10k.zsh.
[[ ! -f ~/.config//zsh//.p10k.zsh ]] || source ~/.config//zsh//.p10k.zsh
