#!/usr/bin/env bash
# vim: ts=2 sw=2 sts=2 et :

Ell="$(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )"

alias ..='cd ..'
alias ...='cd ../../../'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gp="git add *;git commit -am save;git push;git status"
alias hello="git pull"
alias bye="gp; tmux detach"
alias h="history"
alias ls="ls -G"
alias tmux="tmux -f $Etc/etc/tmux-conf "
alias vi="vim -u $Etc/etc/vimrc "
alias vims="vim +PluginInstall +qall"         

prep() { 
sed -f prep 
}

here() { cd $1; basename `pwd`; }
PROMPT_COMMAND='echo -ne "🐤 $(git branch 2>/dev/null | grep '^*' | colrm 1 2):";PS1="$(here ..)/$(here .):\!\e[m ▶ "'

hi() {
  tput bold; tput setaf 5
  cat<<'EOF'
        .-"-.
       /  ,~a\_
       \  \__))>
       ,) ." \
      /  (    \
     /   )    ;
    /   /     /  KEYS0
  ,/_."`  _.-`
   /_/`"\\___
        `~~~`
EOF
  tput bold; tput setaf 241
  echo "Short cuts:"
  alias | sed 's/alias //'
  echo ""
  tput sgr0
}

if [ -n "$1" ]; then
  f=${1/%.awk/.awk}
  shift
  cat $1 | prep > $Ell/var/$f
  if [ -t 0 ]
  then       gawk -f $Ell/var/$f $*
  else cat -|gawk -f $Ell/var/$f $*
  fi
else
  hi
fi
