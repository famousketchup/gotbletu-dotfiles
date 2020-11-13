#!/bin/bash
# source: http://www.linuxquestions.org/questions/linux-newbie-8/time-difference-calculation-4175459414/#post4937901
# source: http://linuxconfig.org/bash-script-display-usage-and-check-user
display_usage() { 
	echo "use ffmpeg to slice videos" 
	echo -e "\nUsage:\n$0 [file] [starttime] [finishtime] \n" 
	echo -e "\nexample:\n$0 filename.avi 00:01:00 00:05:00 \n" 
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

# code
BEGINTIME=${2}
ENDTIME=${3}

# Convert the times to seconds from the Epoch
SEC1=`date +%s -d ${BEGINTIME}`
SEC2=`date +%s -d ${ENDTIME}`

# Use expr to do the math, let's say TIME1 was the start and TIME2 was the finish
DIFFSEC=`expr ${SEC2} - ${SEC1}`
DURATIONTIME=`date +%H:%M:%S -ud @${DIFFSEC}`

ffmpeg -i "$1" -ss ${BEGINTIME} -t ${DURATIONTIME} -codec:v copy -codec:a copy "${1%.*}"-sliced."${1##*.}"

