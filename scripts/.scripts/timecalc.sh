#!/bin/bash
# source: http://www.linuxquestions.org/questions/linux-newbie-8/time-difference-calculation-4175459414/#post4937901

display_usage() { 
	echo "Time Calculator - subtracts endtime from begintime" 
	echo -e "\nUsage:\n$0 [begintime] [endtime]" 
	echo -e "\nexample:\n$0 00:01:00 00:05:00 \n" 
	} 
# if less than two arguments supplied, display usage 
	if [  $# -le 1 ] 
	then 
		display_usage
		exit 1
	fi 
 
# check whether user had supplied -h or --help . If yes display usage 
	if [[ ( $# == "--help") ||  $# == "-h" ]] 
	then 
		display_usage
		exit 0
	fi 
 
BEGINTIME=${1}
ENDTIME=${2}

# Convert the times to seconds from the Epoch
SEC1=`date +%s -d ${BEGINTIME}`
SEC2=`date +%s -d ${ENDTIME}`

# Use expr to do the math, let's say TIME1 was the start and TIME2 was the finish
DIFFSEC=`expr ${SEC2} - ${SEC1}`
DURATIONTIME=`date +%H:%M:%S -ud @${DIFFSEC}`


echo Begin ${BEGINTIME}
echo End ${ENDTIME}
echo Takes ${DIFFSEC} seconds
echo End-Begin: ${DURATIONTIME}

