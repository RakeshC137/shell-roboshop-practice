#!/bin/bash

source ./common.sh
APP_NAME="frontend"

check_root

dnf module list nginx &>>$LOGS_FILE
VALIDATE $? "Listing Nginx"

dnf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGS_FILE
systemctl start nginx 
VALIDATE $? "Enabling and starting Nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Removing existing code"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
VALIDATE $? "Downloading Zip code"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOGS_FILE
VALIDATE $? "Unzipping zip code"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf 
VALIDATE $? "Copying Nginx.conf"

systemctl restart nginx
VALIDATE $? "Restarted Nginx"

print_total_time
