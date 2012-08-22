# .bashrc
# User specific aliases and functions
set -o vi

alias cls='clear'
alias grep='grep -r -i -n -H --color=auto'
alias vi='vim'

# User specific aliases and functions
export SANDROOT="/usr/local/html/"
export SANDROOTWORK="/usr/local/work/"
export SANDROOTINT="/usr/local/html/sites/intelius.com/"
export SANDROOTPSCONFIG="/usr/local/html/classes/consumer/report/component/sku/peoplesearch/config"
export SANDROOTPS="/usr/local/html/classes/consumer/report/component/sku/peoplesearch/"
export SANDROOTTEST="/usr/local/html/tests/"
export SANDROOTANNOTATIONS="/usr/local/html/classes/consumer/annotation"
alias html='cd $SANDROOT/'
alias work='cd $SANDROOTWORK/'
alias intel='cd $SANDROOTINT/'
alias iserv='cd $SANDROOT/sites/iservices'
alias titan='cd $SANDROOT/sites/iservices/templates/titan'
alias prem='cd $SANDROOT/sites/iservices/templates/premier'
alias myinf='cd $SANDROOT/sites/iservices/templates/myinfo'
alias cont='cd $SANDROOT/classes/iservices/controller'
alias temail='cd $SANDROOT/core/templates/iservices/titan/email'
alias email='cd $SANDROOT/core/inc/iservices/email'
alias psconfig='cd $SANDROOTPSCONFIG/'
alias test='cd $SANDROOTTEST/'
alias anno='cd $SANDROOTANNOTATIONS/'
#cd $SANDROOT

# Source global definitions
if [ -f /etc/bashrc ]; then
. /etc/bashrc
fi

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Get the aliases and functions
if [ -f ~/.gitcmd ]; then
. ~/.gitcmd
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Run consumer unit tests. if no arg is supplied, run suite other wise run specific tests
function punit()
{
   if [ "$1" = "" ]; then
      eval tests/phpunit "Suites/consumer.inc.php"
   elif [ "$1" = "all" ]; then
      eval tests/phpunit "Suites/tests.inc.php"
   else
      eval tests/phpunit "tests/test/consumer/$1"
   fi   
}

function j()
{
  if [ "$#" -eq "0" ]; then
    export SANDROOT="/usr/local/html/work/$USER/html"
      elif [ ! -d "/usr/local/html/work/$1/html" ]; then
      echo "Sandbox does not exist: "
      echo "/usr/local/html/work/$1/html"
  else
    export SANDROOT="/usr/local/html/work/$1/html"
      fi
      newSandDir=`pwd | sed 's/^\/usr\/local\/html\/work\/[^\/]*\/html//'`
      if [ -d "$SANDROOT$newSandDir" ]; then
        cd "$SANDROOT$newSandDir"
          fi
}

function prunesites()
{
  if [ ! `pwd | grep ^/usr/local/html/work/[^/]*/html/sites$` ]; then
    echo "You must be in a sandbox's /html/sites directory."
  else
    for file in `ls`
      do
        if [ "$file" != intelius.com -a "$file" != peoplelookup.com -a "$file" != lookupanyone.com -a "$file" != secure.publicrecords.com -a "$file" != api -a "$file" != dispatcher ] ; then
          rm -r ./$file
            fi
            done
            fi
}

function search()
{
  if [ -z "$1" ]; then
    echo "USAGE:"
      echo "------"
      echo "  1) search file [filename]"
      echo "  2) search string [string]"
      echo " "
      fi

      echo " "
      if [ $1 = "file" ]; then
        echo "SEARCHING FILES........"
          find . -iname $2 -print
          elif [ $1 = "string" ]; then
          if [ $# -gt 2 ]; then
            echo " Error: please use quotes around the search string"
          else
            echo "SEARCHING STRING........."
              find . -exec grep -nqi "$2" '{}' \; -print
              fi
              fi
}

function grepfunc()
{
  if [ -z "$1" ]; then
    echo "USAGE: grepfunc [directory] [file_extensio] [pattern]"
      echo "Example: grepfunc . php foo"
      fi

      find $1 -name "*.$2" -exec grep -n -H --color=auto "$3" '{}' \;
}

# Run unit test on akellberg
function ak()
{
   cd /usr/local/html/tests
   eval ./phpunit --log-junit ~/UnitResults/AK.`date +%m.%d.%y_%I.%M.%S`.xml Suites/all.inc.php | tee ~/ConsoleOut/AK.`date +%m.%d.%y_%I.%M.%S`.txt
}

# Branch recent, grabs the 10 most recently modified branches
function br()
{
    for k in `git branch|perl -pe s/^..//`;do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k|head -n 1`\\t$k;done|sort -r | head -10
}

# List files from the most current commit
function gitf()
{
  git log --name-status 
}

#remove log files
function removeLogs()
{
   su
   cd /tmp
   rm stats.*
   rm ds3.*
   rm /tmp/*.log
   rm /tmp/qcachestats.*
   rm /tmp/query.*
   rm /tmp/stats.*
   rm /tmp/*.err
}

function cs()
{
   cd $1
   ls
}

function scoreboard()
{
   git shortlog -s -n
}

function iservstatus()
{
   grep define.*ISERVICE_SERVICEGROUPSTATUS /usr/local/html/core/inc/iservice.conf.php
}

#customize shell 
#cd $SANDROOT
#export __git_ps1=`git symbolic-ref HEAD|colrm 1 11`
#export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[01;33m\] ($__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '

source ~/git-completion.bash
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '
#export GIT_PS1_SHOWDIRTYSTATE=1
export LS_COLORS='di=33;44'
export DISPLAY=dvm-nrushton2.tuk2.intelius.com
