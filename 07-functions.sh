#!/bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
   echo "Run this script as root user"
   exit 1
fi

VALIDATE(){
  if [ $1 -ne 0 ]; then
    echo "$2 installtion FAILURE"
  else
    echo "$2 installtion SUCCESS"
  fi
}

echo "installing Nginx"
dnf install nginx -y
VALIDATE $? "NGINX"

echo "installing mysql"
dnf install mysql -y
VALIDATE $? "MYSQL"

