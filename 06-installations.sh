#!/bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
   echo "Run this script as root user"
   exit 1
fi

echo "installing Nginx"
dnf install nginx -y

if [ $? -ne 0 ]; then
   echo "Nginx installtion FAILURE"
else
   echo "Nginx installtion SUCCESS"
fi

dnf install mysql -y
echo "installing mysql"

if [ $? -ne 0 ]; then
   echo "mysql installtion FAILURE"
else
   echo "mysql installtion SUCCESS"
fi