#!/bin/bash

USER_ID=$(id -u)
LOG_FOLDER="/var/log/shell/"
LOG_FILE="/var/log/shell/$0.log"

if [ $USER_ID -ne 0 ]; then
   echo "Run this script as root user"
   exit 1
fi

mkdir -p $LOG_FOLDER

VALIDATE(){
  if [ $1 -ne 0 ]; then
    echo "$2 installtion FAILURE"
    exit 1
  else
    echo "$2 installtion SUCCESS"
  fi
}

echo "installing Nginx"
dnf install nginx -y &>> $LOG_FILE
VALIDATE $? "NGINX"

echo "installing mysql"
dnf install mysql -y &>> $LOG_FILE
VALIDATE $? "MYSQL"

echo "installing nodejs"
dnf install nodejs -y &>> $LOG_FILE
VALIDATE $? "MYSQL"