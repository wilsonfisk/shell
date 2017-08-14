# Custom Prompt: '$time $user@$host [$cwd] $'
# red prompt for root and green prompt for users
RST="\[\e[00m\]"
LRED="\[\e[1;91m\]"
LGRN="\[\e[1;92m\]"
LBLU="\[\e[1;94m\]"
LMAG="\[\e[1;95m\]"

if [[ $EUID == 0 ]]; then
    PS1="$LBLU\A$RST $LRED[$RST$LMAG\w$RST$LRED] \\$>$RST "
else
    PS1="$LBLU\A$RST $LGRN[$RST$LMAG\w$RST$LGRN] \\$>$RST "
fi

unset RST RED GREEN CYAN
