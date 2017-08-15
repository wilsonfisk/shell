# reload: reload .bashrc
alias reload='. ~/.bashrc'

# check if option is available then set alias
alias cp='cp -i'
[[ $(diff --color=auto 2>/dev/null) ]] && alias diff='diff --color=auto'
[[ $(egrep --color=auto 2>/dev/null) ]] && alias egrep='egrep --color=auto'
[[ $(fgrep --color=auto 2>/dev/null) ]] && alias fgrep='fgrep --color=auto'
[[ $(grep --color=auto 2>/dev/null) ]] && alias grep='grep --color=auto'
alias ls='ls -al -I "." -I ".." --color=auto'
alias mv='mv -i'
alias rm=rm -i'
