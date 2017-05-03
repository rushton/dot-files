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

#############################################################################
# gnuplot shortcuts
### gnu plot does support input from stdin, but does not support plotting
### multiple lines from stdin, thus we write the raw data to /tmp/gnuplotdata.
### Not ideal for large datasets but ¯\_(ツ)_/¯
### Requires: git@github.com:Gnuplotting/gnuplot-palettes.git in home dir for nicer colors
##############################################################################
autotitle="set key autotitle columnhead;"
plotcommand="load '~/gnuplot-palettes/dark2.pal'; plot for [i=2:20] '/tmp/gnuplotdata' using 1:i ls i lw 3 with lines;"
# "set format x" sets the display style for the date
# "set bmargin" sets the bottom margin for the graph, this allows the x labels to be taller while staying visible
# "set xtics rotate by" rotates the x labels 45 degress, which makes them readable
# "set xtics offset" modifies the positioning so they are correctly aligned witht the x graph tics
plotcommanddate="set timefmt '%Y-%m-%dT%H:%M:%S';set format x '%Y-%m-%d'; set bmargin 5.0; set xtics rotate by 45 offset -6.4,-3.2; set xdata time;$plotcommand"

# simple plot, assumes first column as the y-axis, any columns after that are plotted separately
alias plot="tee /tmp/gnuplotdata > /dev/null &&  gnuplot -p -e \"$plotcommand\" &> /dev/null && rm /tmp/gnuplotdata;"

# same as plot but take the first line and assumes it contains the column headers, uses them for the legend
alias plotautotitle="tee /tmp/gnuplotdata > /dev/null &&  gnuplot -p -e \"$autotitle;$plotcommand\" &> /dev/null && rm /tmp/gnuplotdata;"

# turns on stderr logging from gnuplot
alias plotdebug="tee /tmp/gnuplotdata > /dev/null &&  gnuplot -p -e \"$plotcommand\" && rm /tmp/gnuplotdata;"

# same as plot, but assumes the first column is a date in the form <year>-<month>-<day>T<hour>:<minute>:<second>
alias plotdate="tee /tmp/gnuplotdata > /dev/null &&  gnuplot -p -e \"$plotcommanddate\" 2>/dev/null && rm /tmp/gnuplotdata;"

# same as plot date, but with the same functionality as plotautotitle
alias plotdateautotitle="tee /tmp/gnuplotdata > /dev/null &&  gnuplot -p -e \"$autotitle;$plotcommanddate\" 2>/dev/null && rm /tmp/gnuplotdata;"

# debug date plot
alias plotdatedebug="tee /tmp/gnuplotdata > /dev/null &&  gnuplot -p -e \"$plotcommanddate\" && rm /tmp/gnuplotdata;"

# instead of plotting to a png, this plots ascii graph to the terminal
alias plotdumb="tee /tmp/gnuplotdata > /dev/null &&  gnuplot -p -e \"set terminal dumb;$plotcommand;\" &> /dev/null && rm /tmp/gnuplotdata;"

# same as plotdumb, but for dates
alias plotdatedumb="tee /tmp/gnuplotdata > /dev/null &&  gnuplot -p -e \"set terminal dumb;$plotcommanddate;\" &> /dev/null && rm /tmp/gnuplotdata;"


# set of functions to convert bytes to various forms
alias mb="awk '{print \$1/1024/1024, \"MB\"}'"
alias gb="awk '{print \$1/1024/1024/1024, \"GB\"}'"
alias tb="awk '{print \$1/1024/1024/1024/1024, \"TB\"}'"

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
