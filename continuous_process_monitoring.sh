#!/bin/bash
  
# This script continuously monitors processes and checks if a process has more than a certain number of active children. If so, it sends an email with process information.
# Also appends the results to a log every hour.

# registers the first starttime for logging
starttime=$SECONDS
# counts how many processes found with exceeding number of active children
pids_count=0
# email address
email="root"
# assign default value of 5 to the max number of active children (can be changed by passing an argument to the script)
if [[ $# -eq 0 ]]
then
	max_children=5
else
	max_children=$1
fi

# path to log
logpath="/home/$USER/log"
touch $logpath

printf "[%(%M:%H:%S %d/%m/%y)T] Script started\n" >> $logpath

# getting pids of active processes and iterating through them (lsof -r 5 makes lsof run in repeat mode with a delay of 5 seconds)
lsof -t -r 5 | while read line
do
	# the file /proc/$line/task/$line/children contains the pids of the children of some active process.
	# so by counting the words with "wc -w" we can effectively count how many children a pid has spawned.
	# redirecting the stderr so we get only the processes which have children
	count=`cat /proc/$line/task/$line/children 2>/dev/null | wc -w`
    if [ $count -ge $max_children ]
	then
		# get the info of the parent process spawning the excessive number of children
		process_info=`ps aux | grep $line | head -n 1`
		
		# write the file to send via email with the info about the process
		touch tmp_log
		echo "Subject: Process monitoring warning" >> tmp_log
		echo "[WARNING]" >> tmp_log
		echo "Process spawned more than $max_children children" >> tmp_log
		echo "" >> tmp_log
		echo "PROCESS INFO:" >> tmp_log
		printf "User: " >> tmp_log
		awk '{print $1}' <<< $process_info >> tmp_log
		printf "Time: " >> tmp_log
		awk '{print $9}' <<< $process_info >> tmp_log
		printf "Parent Name and PID: " >> tmp_log
		awk '{print $11" "$2}' <<< $process_info >> tmp_log
		printf "Children PIDs: " >> tmp_log
		cat /proc/$line/task/$line/children >> tmp_log
		echo "" >> tmp_log
		
		# send email
		sendmail $email < tmp_log
		# append the file to the log
		printf "[%(%M:%H:%S %d/%m/%y)T] Process with more than $max_children active children info:\n"
		cat tmp_log | tail -n 5 >> $logpath
		# cleanup the file
		rm tmp_log
		# counting how many processes we found to append it to the log
        pid_count=$(( $pid_count + 1 ))
	fi
	
	# endtime for logging
	end=$SECONDS
	# if 1 hour passes we append the count to a log
	if [ $(( $end - $starttime )) -gt $(( 60*60 )) ]
	then
		printf "[%(%M:%H:%S %d/%m/%y)T] Found $pids_count processes with more than $max_children children\n" >> $logpath
		# refresh the starttime variable to restart the hour count
		starttime=$SECONDS
	fi
done
