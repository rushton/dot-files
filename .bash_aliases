#Make some possibly destructive commands more interactive.
alias rm='rm -rf'
alias mv='mv -f'
alias cp='cp -rf'

alias ll='ls -l -h'
alias la='ls -la -h'

# git aliai
alias s='git status'

alias tmux='LD_LIBRARY_PATH=/usr/local/lib TERM=xterm-256color tmux'
alias git-recent="git for-each-ref --sort=-committerdate refs/heads/ | awk -F"/" '{print $NF}' | head -n20"

alias s3='fasts3'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'

alias sum="awk '{total = total + \$1}END{print total}'"
alias generalstats="awk 'BEGIN{max=0;}{sum+=\$1;count+=1;if(\$1>max){max=\$1}}END{if(count<=0){average=0}else{average=sum/count} printf \"Sum: %s -- Count: %s -- Average: %.2f -- Max: %s\n\", sum, count, average, max}'"
alias h='history'
alias ntosp="sed ':a;N;\$!ba;s/\n/ /g'"
alias ntocomma="sed ':a;N;\$!ba;s/\n/,/g'"

starttmux() {
    tmux new-window "ssh $1"
    for var in "${@:2}"
    do
        tmux split-window -h "ssh $var"
    done
    tmux select-layout tiled > /dev/null
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
}
