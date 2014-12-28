#!/bin/bash

#Define Fan-Levels
f0="0"
f1="10"
f2="20"
f3="30"
f4="40"
f5="50"
f6="60"
f7="70"
f8="80"
f9="90"
f10="100"

#Define Temperature-File
tempfile="/var/temperature-humidity-monitor/www/data/rack_current.txt"

#Read current temp

#currenttemp="40" #currently dummy, change later
currenttemp_raw=`cat $tempfile`

echo $currenttemp_raw

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
