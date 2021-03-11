#!/bin/bash
# Script to find out the path of all the files or directories in all the subdirectories of the current directory
# run command like: ./finder --options --target-directory
# options: -f -> searches for files
#	   -d -> searches for directories
# target_directory -> parent directory to search


if [ $# != 2 ]
then
	echo '*** Error: script needs 2 paremeters [ option, target directory ] ***'
	exit 1
fi

if [ -z $1 ]
then
	echo '*** Error: script needs "-f" or "-d" as parameter ***'
	exit 1
	
elif [ $1 == "-f" ]
then
	ls -lR $2 | grep ^- | awk '{print $9}' | while read fname
	do
		find $2 -name "${fname}"
	done

elif [ $1 == "-d" ]
then
	ls -lR $2 | grep ^d | awk '{print $9}' | while read fname
	do
		find $2 -name "${fname}"
	done

else
	echo '*** Error: wrong paremeter ***'
	echo '"-f" for file search'
	echo '"-d" for directory search'
fi

