#!/bin/bash

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

#Read current temp

currenttemp=`awk -F':' '{ print $2 }' $tempfile`
currenttemp=${currenttemp%.*} #round to integer

#Initiate wiring-pi, mode PWM, PWM-Range 100
gpio mode 1 pwm #Wiringpi Port 1 = Physical GPIO18
gpio pwmr 100 #Range from 0 to 100

#Get Fanlevel
if ((currenttemp<=25))
then
    fanlevel="$f0"
    fanlog="0"
elif ((26<=currenttemp && currenttemp<=29))
then
    fanlevel="$f3"
    fanlog="3"
elif ((30<=currenttemp))
then
    fanlevel="$f10"
    fanlog="10"
fi

#Set PWM
pwmval=$fanlevel
gpio pwm 1 $pwmval

echo "fanlevel $fanlog, pwm-value $pwmval"
