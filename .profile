#     ~/.profile     #
export QT_QPA_PLATFORMTHEME="qt5ct"     # Qt themes for non-Qt DEs/WMs
# Default programs                      # Default programs
export EDITOR="nvim"                    # Terminal text editor
export VISUAL="$EDITOR"                 # Graphical text editor
export TERMINAL="st"                    # Terminal
export BROWSER="firefox"                # Web Browser
export FILE="dolphin"                   # File manager
export FZF_DEFAULT_OPTS="--layout=reverse --height 60%"

export __GL_SHADER_DISK_CACHE_PATH="$HOME/.config/nv"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export XDG_CONFIG_HOME="$HOME/.config"


# Custom ls colours
eval "$(dircolors ~/.config/dircolors)"

# Places where binaries/scripts go so you dont have to type the whole path to run them
export PATH="$(find ~/bin/ -maxdepth 1 -type d | tr '\n' ':')$HOME/.local/bin:$PATH"

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'       # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'       # begin blink
export LESS_TERMCAP_me=$'\E[0m'          # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m'   # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'          # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'       # begin underline
export LESS_TERMCAP_ue=$'\E[0m'          # reset underline

shortcuts

if [[ "$TERM" = "linux" ]]; then
	( source tty-colours.sh & )
	( sudo /usr/bin/kbdrate -d 200 -r 60 &>/dev/null & )
	#clear #for background artifacting
fi
