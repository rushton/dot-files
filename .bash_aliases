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
alias runningsum="awk 'BEGIN{total=0}{total = total + \$1; print \$1, total; fflush()}'"

# Sums values by key
# Params:
# $1 - index of the key you want to group by (default: 1)
# $2 - index of the value you want to sum (default: 2)
function sumbykey() {
    key_index=${1:-1}
    value_index=${2:-2}
    awk -v key_index="$key_index" -v value_index="$value_index" '{a[$(key_index)]+= $(value_index)}END{for(k in a){print k, a[k]}}'
}

alias vi='nvim'

alias pqdump='java -jar ~/Downloads/Parquet-Dump-assembly-1.1.1.jar'

# echo to stderr instead of stdout
alias echostderr=">&2 echo"

if [ $(command -v gsed) ]; then
    alias thousands="gsed --unbuffered ':a;s/\B[0-9]\{3\}\>/,&/;ta'"
else
    alias thousands="sed --unbuffered ':a;s/\B[0-9]\{3\}\>/,&/;ta'"
fi

# prints a line every nth line, always includes the last line
# Args:
#   $1 - int determining n
function every () {
    awk -v nth="$1" '(NR-1)%nth==0{print}END{print}'
}

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
alias generalstats="sort -n | awk 'BEGIN{
    sum=0
    average=0
    print \"sum count average median min max\"
}{
    sum+=\$1
    if(\$1>max){
        max=\$1
    }
    median_arr[n++]=\$1
}END{
    count=length(median_arr)
    if(count>0){
        average=sum/count
    }
    if (length(median_arr) % 2) {
        median=median_arr[(length(median_arr)+1)/2]
    } else {
        median=(median_arr[length(median_arr)/2] + median_arr[(length(median_arr)/2) + 1]) / 2.0
    }
    print sum, count, average, median, median_arr[0], median_arr[length(median_arr) - 1]
}' | column -t"
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

function tshirt() {
    PID=$$
    DIVISOR=$(echo "$1" | awk 'BEGIN{divisor=1}/mb/{divisor=1*1024*1024}END{printf "%.1f", divisor}')
    cat | sort -n > /tmp/tshirt.$PID
    sum=$(awk '{s+=$1}END{print s}' /tmp/tshirt.$PID)
    gawk -v divisor=$DIVISOR -v third=$(echo $sum"/3" | bc) '
    current_sum >= third{
        sums[i++]=current_sum
        counts[j++]=current_count
        max[k++]=median_arr[length(median_arr)-1]
        min[l++]=median_arr[0]
        if (length(median_arr) % 2) {
            median[m++]=median_arr[(length(median_arr)+1)/2]
        } else {
            median[m++]=(median_arr[length(median_arr)/2] + median_arr[(length(median_arr)/2) + 1]) / 2.0
        }

        current_sum=current_count=n=0
        delete median_arr

    }
    {
        current_sum+=$1
        current_count+=1
        median_arr[n++]=$1
        total_sum+=$1
        total_count+=1
    }
    END {
        sums[i++]=current_sum
        counts[j++]=current_count
        max[k++]=median_arr[length(median_arr) - 1]
        min[l++]=median_arr[0]
        if (length(median_arr) % 2) {
            median[m++]=median_arr[(length(median_arr)+1)/2]
        } else {
            median[m++]=(median_arr[length(median_arr)/2] + median_arr[(length(median_arr)/2) + 1]) / 2.0
        }

        for(k in sums){
            printf "%d %d %.3f %.3f %.3f %.3f %.3f\n",
                sums[k]/divisor,
                counts[k],
                sums[k] / counts[k] / divisor,
                median[k]/divisor,
                min[k]/divisor,
                max[k]/divisor,
                (counts[k] / total_count)*100
        }
    }' /tmp/tshirt.$PID | \
    awk 'BEGIN{
        print "size sum count average median min max pct_of_total_count"
    }
    NR==1{sz="small"}
    NR==2{sz="medium"}
    NR==3{sz="large"}
    {print sz, $0}'  | column -t
    rm /tmp/tshirt.$PID
}
