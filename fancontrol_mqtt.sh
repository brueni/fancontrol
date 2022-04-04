#!/bin/bash
cd `dirname $0`
#Define Fan-Levels
f0="0"
f1="20"
f2="23"
f3="26"
f4="29"
f5="32"
f6="35"
f7="38"
f8="42"
f9="46"
f10="50"

#Define Temperature-File
tempfile="/etc/temperature-humidity-monitor/data/rack_t_current.txt"

#Define Mode-File
modefile="mode.txt"

#Define Location of GPIO-Binary
gpiobin="/home/pi/WiringPi/gpio/gpio"

#Read current temp
currenttemp=`cat $tempfile`
currenttemp=${currenttemp%.*} #round to integer

#Read current Mode
#0=Automatic
#1=Fan off
#2=Fan full
currentmode=`cat $modefile`

#Initiate wiring-pi, mode PWM, PWM-Range 100
$gpiobin mode 1 pwm #Wiringpi Port 1 = Physical GPIO18
$gpiobin pwmr 100 #Range from 0 to 100

#Get Fanlevel
if ((currentmode==0))
then
	if ((currenttemp<=25))
	then
	    fanlevel="$f0"
	    fanlog="0"
	elif ((currenttemp == 26))
	then
	    fanlevel="$f1"
	    fanlog="10"
	elif ((currenttemp == 27))
	then
	    fanlevel="$f2"
	    fanlog="20"
	elif ((currenttemp == 28))
	then
	    fanlevel="$f4"
	    fanlog="40"
	elif ((currenttemp == 29))
	then
	    fanlevel="$f6"
	    fanlog="60"
	elif ((currenttemp == 30))
	then
	    fanlevel="$f7"
	    fanlog="70"
	elif ((currenttemp == 31))
	then
	    fanlevel="$f8"
	    fanlog="80"
	elif ((currenttemp == 32))
	then
	    fanlevel="$f9"
	    fanlog="90"
	elif ((33<=currenttemp))
	then
	    fanlevel="$f10"
	    fanlog="100"
	fi
elif ((currentmode==1))
then
	fanlevel="$f0"
	fanlog="0"
elif ((currentmode==2))
then
	fanlevel="$f10"
	fanlog="100"
fi

#Set PWM
pwmval=$fanlevel
$gpiobin pwm 1 $pwmval

echo "mode $currentmode, fanlevel $fanlog, pwm-value $pwmval"

#Update RRD
#rrdinput="N:$fanlog"
#$(rrdtool update data/fan.rrd $rrdinput)

#Write Current-File
echo $fanlog > /etc/temperature-humidity-monitor/data/rack_f_current.txt

#Send through MQTT to openHAB
mosquitto_pub -h vm05openhab -t /rack/stat/fanlevel -m $fanlog
