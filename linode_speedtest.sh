#!/bin/bash

# Testing download speed from Linode facilities listed at https://www.linode.com/speedtest/
# Note that Linode's server list might change. You're welcome to notify me or send a pull request if the script should be updated.
# Created by Niklas Berglund. Released under MIT license.
# https://github.com/niklasberglund/linode_speedtest

server_name=(
	"Tokyo"
    "Singapore"
	"London"
    "Frankfurt"
	"Newark"
	"Atlanta"
	"Dallas"
	"Fremont"
)

server_url=(
	"speedtest.tokyo.linode.com/100MB-tokyo.bin"
    "speedtest.singapore.linode.com/100MB-singapore.bin"
	"speedtest.london.linode.com/100MB-london.bin"
    "speedtest.frankfurt.linode.com/100MB-frankfurt.bin"
	"speedtest.newark.linode.com/100MB-newark.bin"
	"speedtest.atlanta.linode.com/100MB-atlanta.bin"
	"speedtest.dallas.linode.com/100MB-dallas.bin"
	"speedtest.fremont.linode.com/100MB-fremont.bin"
)

server_starttransfer=()
server_speed_download=()

trap finish EXIT

function finish {
    echo ""
    # result table
    printf "\x1b[7m%-20s | %-20s | %-20s\x1b[0m\n" "Server location" "Avg. download speed" "Start time"

    j=0

    for s in ${server_name[@]}
    do
        if [ -z ${server_speed_download[$j]} ]
        then
            server_speed_download[$j]="- "
        fi
        
        if [ -z ${server_starttransfer[$j]} ]
        then
            server_starttransfer[$j]="- "
        fi
        
    	printf "%-20s | %-20s | %-20s\n" ${server_name[$j]} "${server_speed_download[$j]}kb/s" "${server_starttransfer[$j]}s"
    	((j++))
    done

    echo ""
}

i=0

# measure speed
for s in ${server_name[@]}
do
	echo "Measuring ${server_name[$i]} server download speed"	
	result=$(curl -o /dev/null --progress-bar -w "%{time_starttransfer} %{speed_download}" ${server_url[$i]})
	
	server_starttransfer[$i]=$(echo $result | cut -d " " -f 1)
	server_speed_download[$i]=$(echo $result | cut -d " " -f 2)
	server_speed_download[$i]=$(echo "scale=2; ${server_speed_download[$i]}/1024" | bc -l)
	
	echo ""
	((i++))
done
