#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/home/ec2-user/app_logs"
LOGS_FILE="/home/ec2-user/$0.log"

if [ ! -d $LOGS_FOLDER ]; then
  echo "$LOGS_FOLDER does not exist"
  exit 1
fi

FILES_TO_DELETE=$(find $LOGS_FOLDER -name "*.txt" -mtime +14)
echo "$FILES_TO_DELETE"

if [ -z "${FILES_TO_DELETE}" ]; then
   echo "No files to delete"
else
  while IFS= read -r filepath;
  do
    echo "deleting file $filepath"
    rm -f $filepath
    echo "deleted file $filepath"
  done <<< $FILES_TO_DELETE
fi
   

