HISTFILE=~/.config/zsh/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt globdots
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit

alias ls='ls -la --color=auto'
alias makedwm='cd ~/.config/suckless/dwm & rm -rf config.h & sudo make clean install'
alias dotfiles='git --git-dir=$HOME/dotfiles --work-tree=$HOME'

source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

eval "$(starship init zsh)"
