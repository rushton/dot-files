#Make some possibly destructive commands more interactive.
alias rm='rm -rf'
alias mv='mv -f'
alias cp='cp -rf'

alias ll='ls -l -h'
alias la='ls -la -h'

# Most computers have a reasonable amount of RAM, this will make
# sort rely less on caching results to disk and use memory instead.
alias sort='sort --buffer-size=1024M'

# git alias
alias s='git status'

alias tmux='LD_LIBRARY_PATH=/usr/local/lib TERM=xterm-256color tmux'
alias git-recent="git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname)' | sed 's/refs\/heads\///g'"

alias s3='fasts3'
alias urldecode="python -c \"import urllib;import sys; print '\n'.join([urllib.unquote(line.rstrip()) for line in ([sys.argv[1]] if len(sys.argv) > 1 else sys.stdin)])\""

alias sum="awk '{total = total + \$1}END{print total}'"
alias vi='nvim'

# echo to stderr instead of stdout
alias echostderr=">&2 echo"

#Ctags, thx @lorainekv
alias gentags='ctags -R -f ./.git/tags $(pwd)'     
# generate tags for python, excludes import lines.
alias genpytags='ctags -R --python-kinds=-i -f .git/tags $(pwd)'

# source gnuplot aliases
if [ -f ~/.gnuplot_aliases ]; then
    source ~/.gnuplot_aliases
fi

# set of functions to convert bytes to various units back and forth

# Usage:
# tb [num_tb]
# given num_tb, the function will echo the number of bytes
# given stdin, the function will convert the first space tokenized value to terabytes                                                                                        
function tb () {                                                           
    if [ $# -eq 0 ]; then                            
        awk '{print $1/1024/1024/1024/1024, "TB"}'                         
    else                                                                                                                                                                                                            
        echo $(($1 * 1024 * 1024 * 1024 * 1024)) "B"                                    
    fi          
}

# Usage:
# tb [num_gb]
# given num_gb, the function will echo the number of bytes
# given stdin, the function will convert the first space tokenized value to gigabytes
function gb () {                                     
    if [ $# -eq 0 ]; then                                                                                                                                                                                           
        awk '{print $1/1024/1024/1024, "GB"}'
    else                                             
        echo $(($1 * 1024 * 1024 * 1024)) "B"           
    fi                                               
}                         

# Usage:
# tb [num_mb]
# given num_mb, the function will echo the number of bytes
# given stdin, the function will convert the first space tokenized value to megabytes
function mb () {
    if [ $# -eq 0 ]; then
        cat /dev/stdin | awk '{print $1/1024/1024, "MB"}'
    else
        echo $(($1 * 1024 * 1024)) "B"
    fi
}

alias generalstats="awk 'BEGIN{max=0;}{sum+=\$1;count+=1;if(\$1>max){max=\$1}}END{if(count<=0){average=0}else{average=sum/count} printf \"Sum: %s -- Count: %s -- Average: %.2f -- Max: %s\n\", sum, count, average, max}'"
alias h='history'
alias ntosp="sed ':a;N;\$!ba;s/\n/ /g'"
alias ntocomma="sed ':a;N;\$!ba;s/\n/,/g'"

# finds git commits from the last 24 hours authored by me
alias whatdidido='for git_dir in $(find . -name .git -type d -prune);do git --no-pager --git-dir=$git_dir log --pretty=format:"%h - %an, %ar : %s" --since=$(date --date="1 day ago" +"%Y-%m-%dT%H:%M:%S") --author="[rR]ushton" | sed "s#^#${git_dir} #" | awk "{c+=1;print}END{if(c>0){print \"\"}}"; done;'

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

# Opens a tiled tmux window with all the supplied
# hosts ssh'd into
#
# usage: sshall <host1> <host2> <host3> ...
function sshall() {                         
    tmux new-window                         
    for h in $@                             
    do                                      
        tmux send-keys "ssh $h" Enter       
        tmux split -h                       
        tmux select-layout tiled            
    done                                    
    tmux kill-pane                          
    tmux select-layout tiled                
}
