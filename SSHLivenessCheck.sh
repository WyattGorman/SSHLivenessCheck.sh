#!/bin/bash

# SSH Liveness Check Script
# Script attempts to SSH into specified hosts, run the specifed command
# and check for the expected response.
# Usage: ./SSHLivenessCheck.sh [user@example.com] [host_file]

# Author: Wyatt Gorman

# TODO:
#       Lock to prevent repeat "host down" messages
#       Email subject lines
#       Group "host down" messages into single email
#       Add email check

main() {
	if [ z"$1" == "z" ] || [ z"$2" == "z" ]; then
                echo "Usage: ./SSHLivenessCheck.sh [user@example.com] [host_file] [optional: --reset]"
                exit -1
        fi

	if [ -a $1 ]; then
		if [ "`cat $1 | wc -l`" == "0" ]; then
                	echo "The alert emails file \"SSHLivenessCheck_Emails\" is empty!"
                	exit -1
        	fi
		while read LINE ; do
			if [ "`echo $LINE | grep -v "#" | wc -l`" != "0" ]; then
				emails=(${emails[@]} $LINE)
                	fi
        	done < $1
	else
		if [[ $1 =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]; then
                	emails=($1)
		fi
	fi

	if [ -a $2 ]; then
		if [ "`cat $2 | grep -v "#" | wc -l`" == "0" ]; then
                	echo "The hosts file \"SSHLivenessCheck_Hosts\" is empty!"
                	exit -1
        	fi
		while read LINE ; do
                	if [ "`echo $LINE | grep -v "#" | wc -l`" != "0" ]; then
                        	temparray=(`echo $LINE`)
        			hosts=(${hosts[@]} ${temparray[@]})
			fi
		done < $2
	else
		hosts=($2)
	fi

	for((i=0; i<${#hosts[@]}; i=$i+4)); do
		if [ "${hosts[i+2]}" != "`ssh -o ConnectTimeout=3 ${hosts[i+3]} ${hosts[i]} "${hosts[i+1]}" 2>&1`" ]; then
                	for j in ${emails[@]}; do
				echo "Host \"`echo ${hosts[i]} | awk -F "@" '{print $2}'`\" down! @ $j" #| mutt $j 1>&/dev/null
			done
		fi
        done
}

main $1 $2
