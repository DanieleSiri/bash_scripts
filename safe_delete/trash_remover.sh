#!/bin/bash
#automatically deletes files older than 48 hours in TRASH
#to add it to cron do:
#crontab -e
#00 9,17 * * * /path/to/trash_remover.sh

find ~/TRASH -mtime +2 -type f -delete
