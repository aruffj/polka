#     ~/.zprofile     #
. ~/.profile

bindkey '^[[P' delete-char             # Delete key deletes character under cursor
bindkey '^[[1;5C' forward-word         # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word        # [Ctrl-LeftArrow] - move backward one word
bindkey '^[[5~' up-line-or-history     # [PageUp] - Up a line of history
bindkey '^[[6~' down-line-or-history   # [PageDown] - Down a line of history
bindkey '^[[Z' reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
bindkey '^r' history-incremental-search-backward  # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.

setopt auto_cd   # cd by just typing the directory name

# Up arrow key searches up in history
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search

# Down arrow key searches down in history
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=420690
SAVEHIST=420690
setopt extended_history        # record timestamp of command in HISTFILE
setopt hist_expire_dups_first  # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups        # ignore duplicated commands history list
setopt hist_verify             # show command with history expansion to user before running it
setopt inc_append_history      # add commands to HISTFILE in order of execution
setopt share_history           # share command history data

# Better autocompletion
autoload -U compinit && compinit
ZSH_CACHE_DIR=$HOME/.cache/zsh
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Fuzzy autocomplete using LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:*' menu select
setopt auto_menu         # show completion menu on successive tab press
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt complete_in_word
setopt always_to_end

bindkey '^E' end-of-line
bindkey '^A' beginning-of-line

#echo -n -e "\033]0;$(dirs)\007"
#chpwd () { echo -n -e "\033]0;$(dirs)\007" }
