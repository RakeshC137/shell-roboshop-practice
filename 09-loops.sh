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

for package in $@ 
do
  dnf list installed $package &>>$LOG_FILE
    if [ $? -ne 0 ]; then
        echo "$package no installed, installing now"
        dnf install $package -y &>>$LOG_FILE
        VALIDATE $? "$package" 
    else
        echo "$package already installed SKIPPING"
    fi
done