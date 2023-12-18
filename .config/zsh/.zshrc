HISTFILE=~/.config/zsh/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt globdots
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit

alias ls='ls -la --color=auto'
alias dotfiles='git --git-dir=$HOME/dotfiles --work-tree=$HOME'
alias makedwm='cd ~/.config/suckless/dwm & rm -rf config.h & sudo make clean install'
alias search='~/.config/scripts/search'

source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

echo ""
neofetch --config ~/.config/neofetch/blockfetch.conf

eval "$(starship init zsh)"
