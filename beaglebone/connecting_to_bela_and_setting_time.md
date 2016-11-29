# General overview:

- setup network connection
- make sure the clock on the beaglebone has the current time
- update software components from git

#SSH connection

with USB plugged in connect via, standard password is ***a***

	ssh root@192.168.7.2
	
#setup usb internet tethering

## from OSX

Install the drivers, these can be found at:
	http://beagleboard.org/getting-started

###on Mac
	enable Settings/Sharing/Internet sharing 
		Wlan -> BeagleBoneBlack
	
###on BBB
configure network device via dhcp

	sudo dhclient -v usb0

sometimes the ssh connection breaks due to a change of its ip address, reconnect with

	ssh root@beaglebone.local

test if internet connection is working

	ping 8.8.8.8
	ping farnell.nl

eventually add DNS

	echo 'nameserver 8.8.8.8' > /etc/resolv.conf	

as root:
	sudo sh -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'

## from Linux/Ubuntu

*now condensed to a script: ```connect_to_laptop_linux.sh``` in beaglebone directory*

(from http://www.crashcourse.ca/wiki/index.php/BBB_networking_in_tethered_mode)

On the BBB side, manually (as root)

    route add default gw 192.168.7.1
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
    
with sudo:

    sudo route add default gw 192.168.7.1
    sudo sh -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'

And on the server side (your laptop) as root:
*now condensed to a script: ```share_network_with_beaglebone.sh``` in beaglebone directory*


    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -A POSTROUTING -t nat -j MASQUERADE

wit sudo:

    sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
    sudo iptables -A POSTROUTING -t nat -j MASQUERADE


Back on the BBB, test if internet connection is working:

	ping 8.8.8.8
	ping farnell.nl

# synchronize time

*now condensed to a script: ```sync_time.sh``` in beaglebone directory*

    sudo ntpdate -b -u pool.ntp.org

