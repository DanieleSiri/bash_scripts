#!/bin/bash
#script that safe deletes. Files passed from command line will be compressed (if not already) but gzipped and moved to ~/TRASH. The second script uses the cron daemon to delete files older than 48 hours

if [ $# == 0 ]
then 
	echo "script requires 1 argument at least"
	exit 1
fi 

for ((i=1; i<=$#; i++))
do
	#checks if the file is already compressed [${!i} == $1, $2..]
	if [ -z `file ${!i} | grep -o "gzip"` ]
	then
		echo "[+] compressing file ${!i}"
		gzip ${!i}
		echo "*** moving file ${!i}.gz to trash ***"
		mv ${!i}.gz ~/TRASH
	else
		echo "[-] file ${!i} already compressed"
		echo "*** moving file ${!i} to trash ***"
		mv ${!i} ~/TRASH
	fi
done
