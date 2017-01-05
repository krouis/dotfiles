#!/usr/bin/sh
#
# RELAYS
#
## udev rule to put in /etc/udev/rules.d/40-usbrly08.rules :
# SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", SYMLINK+="ttyRLY"
#
## relay through usb
# stty -F /dev/ttyRLY 19200 cs8 cstopb -parenb
# echo 'd' > /dev/ttyRLY
# echo 'n' > /dev/ttyRLY
#ON, OFF
#d , n=all
#e , o=1
#f , p=2
#g , q=3 => cam long
#h , r=4 => cam short
#i , s=5 => pkp
#j , t=6 => usb
#k , u=7 => voldown
#l , v=8 => volup
relay_on=(d e f g h i j k l)
relay_off=(n o p q r s t u v)
#tty_serial=/dev/ttyRELAYB
tty_serial=/dev/ttyRELAYB
board=1
# Relay on/off <relay number>
function rly_on () { echo ${relay_on[$1]} > $tty_serial; }
function rly_off () { echo ${relay_off[$1]} > $tty_serial; }
# Relay on-off <relay number> <duration>
function rly () { rly_on $1; sleep ${2:-0.5}; rly_off $1; }
# Press button, pkp <duration>
function rly_pkp () { rly 5 $1; }
function rly_usb () { rly 6 $1; }
function rly_down () { rly 7 $1; }
function rly_up () { rly 8 $1; }
#
# ALIAS
#
# Usb relay setting
alias rly_set_stty='stty -F $tty_serial 19200 cs8 cstopb -parenb'
# Check relays, on-off all of them
alias rly_check='rly_set_stty; rly 0 1'
# USB plug/unplug
alias rly_plug='rly_off 6'
alias rly_unplug='rly_on 6'
# Open ROS menu
alias rly_ros='rly_on 8; sleep 0.5; rly_on 7; sleep 0.5; rly_off 7; sleep 0.5;rly_off 8'
alias rly_dnx_combo_on='rly_on 7; sleep 1;rly_on 8; sleep 1; rly_pkp 3'
alias rly_dnx_combo_off='rly_off 7; sleep 1; rly_off 8'
