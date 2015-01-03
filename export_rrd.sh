#!/bin/bash
cd `dirname $0`

#exports the data in the RRD to an xml, which can pe parsed by highcharts

#Fan, 3h
rrdtool xport -s now-3h -e now --step 300 \
DEF:a=data/fan.rrd:fan:AVERAGE \
XPORT:a:"Rack-Fan" > /var/temperature-humidity-monitor/www/data/rack_f3h.xml

#Fan, 24h
rrdtool xport -s now-1d -e now --step 900 \
DEF:a=data/fan.rrd:fan:AVERAGE \
XPORT:a:"Rack-Fan" > /var/temperature-humidity-monitor/www/data/rack_f24h.xml

#Fan, 48h
rrdtool xport -s now-2d -e now --step 1800 \
DEF:a=data/fan.rrd:fan:AVERAGE \
XPORT:a:"Rack-Fan" > /var/temperature-humidity-monitor/www/data/rack_f48h.xml

#Fan, 1w
rrdtool xport -s now-1week -e now --step 7200 \
DEF:a=data/fan.rrd:fan:AVERAGE \
XPORT:a:"Rack-Fan" > /var/temperature-humidity-monitor/www/data/rack_f1w.xml

#Fan, 1m
rrdtool xport -s now-1month -e now --step 14400 \
DEF:a=data/fan.rrd:fan:AVERAGE \
XPORT:a:"Rack-Fan" > /var/temperature-humidity-monitor/www/data/rack_f1m.xml

#Fan, 3m
rrdtool xport -s now-3month -e now --step 43200 \
DEF:a=data/fan.rrd:fan:AVERAGE \
XPORT:a:"Rack-Fan" > /var/temperature-humidity-monitor/www/data/rack_f3m.xml

#Fan, 1y
rrdtool xport -s now-1year -e now --step 86400 \
DEF:a=data/fan.rrd:fan:AVERAGE \
XPORT:a:"Rack-Fan" > /var/temperature-humidity-monitor/www/data/rack_f1y.xml

