#!/bin/bash
#script that removes all comments from a script (keeps the first line)

if [ $# != 1 ]
then
	echo "script requires 1 argument (the script to strip)"
	exit 1
fi

if ! [ -a $1 ]
then
    echo "file not found"
	exit 1
fi

sed -i '2,${/^#/d;}' $1