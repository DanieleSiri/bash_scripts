#!/bin/bash
#script that creates an archive of all files modified in last 24 hours in current directory

tar -cvf backup_here `find . -mtime -1 -type f | head -n 1`
find . -mtime -1 -type f | while read line
do
	echo "[+] Found file '$line', adding it to archive.."
	tar -uvf backup_here $line
done
echo "*** Compressing archive ***"
gzip backup_here
