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
tempfile="/var/temperature-humidity-monitor/www/data/rack_current.txt"

#Define Location of GPIO-Binary
gpiobin="/var/wiringPi/gpio/gpio"

#Read current temp
currenttemp=`awk -F':' '{ print $2 }' $tempfile`
currenttemp=${currenttemp%.*} #round to integer

#Initiate wiring-pi, mode PWM, PWM-Range 100
$gpiobin mode 1 pwm #Wiringpi Port 1 = Physical GPIO18
$gpiobin pwmr 100 #Range from 0 to 100

#Get Fanlevel
if ((currenttemp<=22))
then
    fanlevel="$f0"
    fanlog="0"
elif ((currenttemp == 23))
then
    fanlevel="$f1"
    fanlog="10"
elif ((currenttemp == 24))
then
    fanlevel="$f2"
    fanlog="20"
elif ((currenttemp == 25))
then
    fanlevel="$f4"
    fanlog="40"
elif ((currenttemp == 26))
then
    fanlevel="$f6"
    fanlog="60"
elif ((currenttemp == 27))
then
    fanlevel="$f7"
    fanlog="70"
elif ((currenttemp == 28))
then
    fanlevel="$f8"
    fanlog="80"
elif ((currenttemp == 29))
then
    fanlevel="$f9"
    fanlog="90"
elif ((30<=currenttemp))
then
    fanlevel="$f10"
    fanlog="100"
fi

#Set PWM
pwmval=$fanlevel
$gpiobin pwm 1 $pwmval

echo "fanlevel $fanlog, pwm-value $pwmval"

#Update RRD
rrdinput="N:$fanlog"
$(rrdtool update data/fan.rrd $rrdinput)
