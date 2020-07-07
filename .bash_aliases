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

alias git-recent="git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname)' | sed 's/refs\/heads\///g' | head -n10"

alias s3='fasts3'
alias urldecode="python -c \"import urllib;import sys; print '\n'.join([urllib.unquote(line.rstrip()) for line in ([sys.argv[1]] if len(sys.argv) > 1 else sys.stdin)])\""

alias sum="awk 'BEGIN{total=0}{total = total + \$1}END{print total}'"
alias runningsum="awk 'BEGIN{total=0}{total = total + \$1; print \$1, total; fflush()}'"
alias first="awk '{print \$1}'"
alias lst="awk '{print \$NF}'"

# Sums values by key
# Params:
# $1 - index of the key you want to group by
# $2 - index of the value you want to sum
function sumbykey() {
    key_index=${1:-1}
    value_index=${2:-2}
    awk -v key_index="$key_index" -v value_index="$value_index" '{a[$(key_index)]+= $(value_index)}END{for(k in a){print k, a[k]}}'
}

alias countbykey="awk '{a[\$1]+=1; s+=1}END{for(k in a){print k, a[k]}; print \"===\";print \"total\", s}'  | column -t"
alias vi='nvim'
alias date='gdate --iso-8601=seconds'

# echo to stderr instead of stdout
alias echostderr=">&2 echo"

if [ $(command -v gsed) ]; then
    alias thousands="gsed --unbuffered ':a;s/\B[0-9]\{3\}\>/,&/;ta'"
else 
    alias thousands="sed --unbuffered ':a;s/\B[0-9]\{3\}\>/,&/;ta'"
fi

# prints one line of input every nth(determined by param $1) line, 
# always includes the laast line
function every() {
    awk -v nth="$1" '(NR-1)%nth==0{print}{fflush()}END{print}'
}


#Ctags, thx @lorainekv
alias gentags='/usr/local/bin/ctags -R -f ./.git/tags $(pwd)'
# generate tags for python, excludes import lines.
alias genpytags='/usr/local/bin/ctags -R --python-kinds=-i -f .git/tags $(pwd)'

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
        awk '{print $1/1000/1000/1000/1000, "TB"}'
    else
        echo $(($1 * 1000 * 1000 * 1000 * 1000)) "B"
    fi
}

# Usage:
# gb [num_gb]
# given num_gb, the function will echo the number of bytes
# given stdin, the function will convert the first space tokenized value to gigabytes
function gigs () {
    if [ $# -eq 0 ]; then
        awk '{print $1/1000/1000/1000, "GB"}'
    else
        echo $(($1 * 1000 * 1000 * 1000)) "B"
    fi
}

# Usage:
# mb [num_mb]
# given num_mb, the function will echo the number of bytes
# given stdin, the function will convert the first space tokenized value to megabytes
function mb () {
    if [ $# -eq 0 ]; then
        cat /dev/stdin | awk '{print $1/1000/1000, "MB", $0}'
    else
        echo $(($1 * 1000 * 1000)) "B"
    fi
}

# Usage:
# kb [num_kb]
# given num_kb, the function will echo the number of bytes
# given stdin, the function will convert the first space tokenized value to kilobytes
function kb () {
    if [ $# -eq 0 ]; then
        cat /dev/stdin | awk '{print $1/1000, "KB"}'
    else
        echo $(($1 * 1000)) "B"
    fi
}

alias h='history'
alias ntosp="gsed ':a;N;\$!ba;s/\n/ /g'"
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


# opens a tunnel to a consul service and opens the root page in the web browser
# requires CONSUL_HTTP_ADDR to be set
tunnel_service () {
        DC=$(echo "$1" | sed -e 's/b1-prv/b1/' -e 's/g1-iad/g1/' -e 's/a1-prv/a1/')
        SERVICE_NAME=$2
        srv_resp=$(ssh $DC "host -t srv $SERVICE_NAME.service.consul")
        if [ $? -eq 1 ]
        then
            (>&2 echo "Unable to resolve consul name for $SERVICE_NAME")
            exit 1
        fi
        
        echo $srv_resp | sed 's/\.$//' | awk '{print $(NF-1), $NF}' | while read port host
        do
                echo $port $(ssh $DC "dig +noall +answer $host" | awk 'NR==1{print $NF}')
        done | while read port ip
        do
                if [ -z "$TUNNEL_SERVICE_DISABLE_TUNNELING" ] && ! [[ "$DC" =~ ^(b1|a1)$ ]]; then
                    ssh $DC -L $port:$ip:$port 2>/dev/null && (>&2 echo "Tunnel created at localhost:$port")
                    echo "localhost:$port"
                else
                    echo $ip:$port
                fi
                if [ -z "$TUNNEL_SERVICE_DISABLE_OPEN_URL" ]; then
                    if [ -z "$TUNNEL_SERVICE_DISABLE_TUNNELING" ] && ! [[ "$DC" =~ ^(b1|a1)$ ]]; then
                            open http://localhost:$port && (>&2 echo "opened browser tab at 'http://localhost:$port'")
                    else
                        open http://$ip:$port && (>&2 echo "opened browser tab at 'http://$ip:$port'")
                    fi
                fi
        done
}

function _zsh_tunnel_service_completion() {
    local dc

    dc=${words[2]}
    datacenters=$(CONSUL_HTTP_ADDR="$STAGE_CONSUL_HTTP_ADDR" consul catalog datacenters && consul catalog datacenters)
    greppable_datacenters=$(echo $datacenters | tr '\r\n' '|' | sed -e 's/^/|/' -e 's/$/|/')

    # if DC matches the possible DCs
    if [[ "$greppable_datacenters" == *"|$dc|"* ]]; then
        if [[ "$dc" =~ ^(b1-prv|g1-iad|a1-prv)$ ]]; then
            completions=$(CONSUL_HTTP_ADDR="$STAGE_CONSUL_HTTP_ADDR" consul catalog services -datacenter="$dc")
        else
            completions=$(consul catalog services -datacenter="$dc")
        fi
    else
        completions=$datacenters
    fi
    reply=("${(ps:\n:)completions}")
}

function _sh_tunnel_service_completion() {
    dc="${COMP_WORDS[1]}"
    datacenters=$(CONSUL_HTTP_ADDR="$STAGE_CONSUL_HTTP_ADDR" consul catalog datacenters && consul catalog datacenters)
    greppable_datacenters=$(echo $datacenters | sed -e 's/ /|/g' -e 's/^/|/' -e 's/$/|/')

    if [[ "$greppable_datacenters" == *"|$dc|"* ]]; then
        if [[ "$dc" =~ ^(b1-prv|g1-iad|a1-prv)$ ]]; then
            completions=$(CONSUL_HTTP_ADDR="$STAGE_CONSUL_HTTP_ADDR" consul catalog services -datacenter="$dc")
        else
            completions=$(consul catalog services -datacenter="$dc")
        fi
    else
        completions=$datacenters
    fi
    COMPREPLY=($(compgen -W "${completions}" "${COMP_WORDS[2]}"))
}
if type compctl >/dev/null; then
    compctl -K _zsh_tunnel_service_completion tunnel_service
elif type complete >/dev/null; then
    complete -F _sh_tunnel_service_completion tunnel_service
fi




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
