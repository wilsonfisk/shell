# openbsd notes, shell scripts & snippets

## Notes:
### Post Install:
* Upgrade firmware:
  * Using fw_update(1):
    * \# fw_update -v
* Enable the mouse in the terminal:
  * \# vim /etc/rc.conf
    * Change 'wsmoused_flags=NO' to 'wsmoused_flags=YES' then reboot
	* [Additional Info: OpenBSD FAQ](https://www.openbsd.org/faq/faq7.html)
* Set time zone:
  * \# ln -fs /usr/share/zoneinfo/[Country]/[Region] /etc/localtime
* Configure IP address & network mask:
  * \# vim /etc/hostname.em[#]
* Configure gateway IP address:
  * \# vim /etc/mygate
* Configure DNS:
  * \# vim /etc/resolv.conf
* Configure hostname:
  * \# vim /etc/myname
## General Information:
### Shell settings:
  * **Default shell:** ksh
  * ksh first reads '/home/user/.kshrc' then '/home/user/.profile'. The '.profile' file is read only once by the login ksh instance, while the '.kshrc' file is read by each new ksh instance.
  * **Initialization files:**
    * **shell:** ~/.kshrc
	* **user:** ~/.profile
	* **host/all users:** /etc/profile
	* **hardware/software:** /etc/environment
  * \$ echo "export ENV=${HOME}/.kshrc; export ENV" >> .profile
  * Example .kshrc:
```Shell
EDITOR=vim
EMAIL=user@example.com
HISTFILE=~/.ksh_history
HISTSIZE=10000
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
\#LC_CTYPE=en_US.UTF-8
PKG_PATH=ftp://openbsd.mirror.net/pub/OpenBSD/$(uname -r)/packages/$(uname -m)/
ALT_PKG_PATH=http://openbsd.mirror.net/pub/OpenBSD/$(uname -r)/packages/$(uname -m)
## color prompt
RST="\e[00m"; LRED="\e[1;91m"; LGRN="\e[1;92m"; LBLU="\e[1;94m"; LMAG="\e[1;95m"
if [[ $EUID == 0 ]]; then
	PS1="$LMAG\A$RST $LRED[$RST$LBLU\w$RST$LRED] \\$>$RST "
else
    PS1="$LMAG\A$RST $LGRN[$RST$LBLU\w$RST$LGRN] \\$>$RST "
fi; unset RST LRED LGRN LBLU LMAG
export EDITOR EMAIL HISTFILE HISTSIZE LC_ALL LANG PKG_PATH ALT_PKG_PATH PS1
unset MAIL
unset MAILCHECK
\# reload .kshrc
alias reload='. ~/.kshrc'
alias cp='cp -i'
alias ls='ls -A --color=auto'
alias ll='ls -aFhl --color=auto'
alias mv='mv -i'
alias rm='rm -i'
```

### Upgrading to -stable:
  * Using [m:tier](https://www.mtier.org):
    * \$ doas mkdir /root/bin
	* \$ doas ftp -o /root/bin/openup https://stable.mtier.org/openup
	* \$ doas chmod 750 /root/bin/openup
	* \$ echo "#!/bin/sh" > daily.local
	* \$ echo "" >> daily.local
	* \$ echo "Checking for updates..." >> daily.local
	* \$ echo "/bin/sh /root/bin/openup -c" >> daily.local
	* \$ doas mv daily.local /etc/
	* \$ doas chown root:wheel /etc/daily.local
	* \$ doas chmod 644 /etc/daily.local
	* \$ doas /root/bin/openup
	* \$ doas reboot

### Patching OpenBSD:
  * \$ cd /tmp
  * \$ wget .../src.tar.gz
  * \$ wget .../sys.tar.gz
  * \$ cd /usr/src
  * \$ tar xvfz /tmp/sys.tar.gz
  * \$ tar xvfz /tmp/src.tar.gz
  * \$ cd /tmp

### Installing packages:
  * **List installed packages:**
    * \$ pkg_info
	* \$ pkg_info | grep *package_name*
  * **Update installed packages:**
    * \$ doas pkg_add
	* \$ doas pkg_add -u *package_name*
  * **Install a package:**
    * \$ doas pkg_add -ivvv *package_name* | tee package_name.txt
  * **Useful Packages:**
    * **pkg_mgr**: A high-level, user-friendly package browser for OpenBSD. It allows the user to install, uninstall, search & browse available packages using a simple curses interface. It relies on sqlports for its internal database, & **pkg_add**, **pkg_info** and **pkg_delete** for package operations.
  * #### Links:
    * [OpenBSD ports page](https://www.openbsd.org/faq/faq15.html)
	* [OpenPorts.se](http://openports.se)

### Mount a USB drive: (_**Note:** sd0 is used as an example_)
  * Create a directory to mount the USB drive:
    * \# mkdir /mnt/usbkey
	* \# sysctl hw.disknames
	* \# dmesg | grep sd0
	* \# disklabel sd0
  * Mount the USB drive in the created directory:
    * \# mount /dev/sd0i /mnt/usbkey
	* \# cd /mnt/usbkey
	* \# ls -al
  * Unmounting the USB drive:
    * \# umount /mnt/usbkey
### Wireless:
  * Using wpa_supplicant: (_**Note:** urtw0 is used as an example_)
    * Scan for wireless networks:
	  * \$ ifconfig urtw0 up
	  * \$ ifconfig urtw0 scan
	* Connect to WPA network:
	  * \$ ifconfig urtw0 nwid *SSID* wpakey *PASS*
	  * \$ dhclient urtw0
	* Connect to WPA network with spaces in the BSSID:
	  * \$ ifconfig urtw0 nwid '*SSID with spaces*' wpakey *PASS*
	  * \$ dhclient urtw0
	* Connect to WPA network with special characters in the BSSID:
	  * \$ ifconfig urtw0 nwid "*SSID_w!th_$pec!@1_ch@r@cter$*" wpakey *PASS*
	  * \$ dhclient urtw0
	* Monitor Mode:
	  * grep for wireless card information:
	  * \$ dmesg | grep 'urtw0'
	  * Show media options:
	  * \$ ifconfig urtw0 media
      * Enable monitor mode
	  * \$ ifconfig urtw0 mediaopt monitor
	  * Disable monitor mode
	  * \$ ifconfig urtw0 -mediaopt monitor
