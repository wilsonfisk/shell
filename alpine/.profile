# ash first reads the following files (if they exist):
#	   system:		/etc/profile
#	   user:		~/.profile

# Enable UTF-8
export CHARSET=UTF-8
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
source /etc/profile.d/bash_completion.sh
# Tab completion
set completion-ignore-case On
set show-all-if-ambiguous On
# append to history instead of overwriting it
shopt -s histappend
# history file time format
export HISTTIMEFORMAT='%F %T'
#umask 022

for script in /etc/profile.d/*.sh ; do
    if [ -r $script ]
        then . $script
    fi
done
