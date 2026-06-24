#!/bin/bash

source ./common.sh
APP_NAME=redis

check_root

dnf module disable redis -y &>>$LOGS_FILE
dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "Enabling redis-7"

dnf install redis -y &>>$LOGS_FILE
VALIDATE $? "Install redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"

systemctl enable redis &>>$LOGS_FILE
systemctl start redis 
VALIDATE $? "enable and staring redis"

print_total_time
