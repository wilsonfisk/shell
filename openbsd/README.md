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
* Patching OpenBSD:
  * \$ cd /tmp
  * \$ wget .../src.tar.gz
  * \$ wget .../sys.tar.gz
  * \$ cd /usr/src
  * \$ tar xvfz /tmp/sys.tar.gz
  * \$ tar xvfz /tmp/src.tar.gz
  * \$ cd /tmp

* Mount a USB drive: (_**Note:** sd0 is used as an example_)
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
* Wireless:
  * Using wpa_supplicant: (_**Note:** urtw0 is used as an example_)
    * Scan for wireless networks:
	  * \$ ifconfig urtw0 up
	  * \$ ifconfig urtw0 scan
	* Connect to WPA network:
	  * \$ ifconfig urtw0 nwid <SSID> wpakey <PASS>
	  * \$ dhclient urtw0
	* Connect to WPA network with spaces in the BSSID:
	  * \$ ifconfig urtw0 nwid 'SSID with spaces' wpakey <PASS>
	  * \$ dhclient urtw0
	* Connect to WPA network with special characters in the BSSID:
	  * \$ ifconfig urtw0 nwid "SSID_w!th_$pec!@1_ch@r@cter$" wpakey <PASS>
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
