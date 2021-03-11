#!/bin/bash
#log all access to files in /etc during the course of a day. Log filename, access time and if a file was modified

#my home 
logfile="/home/dsiri/scripts/logfile"
#file heading
echo -n "" > $logfile
echo "#this file contains the logs of the past 24 hours in the format" >> $logfile
echo "#FILENAME | ACCESS_TIME | MODIFIED_AT" >> $logfile
echo $logfile

#fill the screen width with - for separating the heading from the content
cols=$(tput cols)
for ((i=0; i<$cols; i++))
do
	printf "-" >> $logfile
done
echo >> $logfile

#find the files accessed in the last day ignoring the permission denied errors
find /etc -atime -1 -type f -print 2>/dev/null | while read line
do
	printf "$line | " >> $logfile
	#stat the file in terse form to cut the line of the access time and get the date
	time=`stat -t $line | cut -d' ' -f12`
	access_time=`date -d @$time`
	printf "$access_time | " >> $logfile
	#check if the file has been modified in the last day
	if [ -n `find /etc -name "$line" -mtime -1 -print 2>/dev/null` ]
	then
		#stat the file in terse form to cut the line of the modification time and get the date 
		mtime=`stat -t $line | cut -d' ' -f13`
		modification_time=`date -d @$mtime`
		printf "$modification_time" >> $logfile
	fi 
	#newline
	echo >> $logfile
done
