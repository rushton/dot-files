# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="cloud"

# Uncomment following line if you want to disable autosetting terminal title.
 DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
 COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/homebrew/bin

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

# remove annoying correction on zsh
unsetopt correct_all

# golang env variables
export GOROOT=/usr/local/opt/go/libexec/
export PATH=$PATH:$GOROOT/bin
export GOPATH=~/gocode/

# set jq colors, everything is default except null values (first index), ordered as:
# - color for `null`
# - color for `false`
# - color for `true`
# - color for numbers
# - color for strings
# - color for arrays
# - color for objects
# first value is style:
# - 1 (bright)
# - 2 (dim)
# - 4 (underscore)
# - 5 (blink)
# - 7 (reverse)
# - 8 (hidden)
# second value is color:
# - 30 (black)
# - 31 (red)
# - 32 (green)
# - 33 (yellow)
# - 34 (blue)
# - 35 (magenta)
# - 36 (cyan)
# - 37 (white)
export JQ_COLORS="2;37:0;39:0;39:0;39:0;32:1;39:1;39"

# stop stupid debian zsh package from moving cursor to
# the beginning of the line when searching history w/
# up arrow
echo 'unsetopt global_rcs' >> ~/.zprofile


export EDITOR=nvim
bindkey '^o^o' edit-command-line

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Make fzf respect .gitignore file
# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/nrushton/.sdkman"
[[ -s "/Users/nrushton/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/nrushton/.sdkman/bin/sdkman-init.sh"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
