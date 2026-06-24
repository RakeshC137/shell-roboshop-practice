#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo Repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing Mongodb"

systemctl enable mongod &>>$LOGS_FILE
systemctl start mongod 
VALIDATE $? "Enabling and Starting mongodb"

sed -i s/127.0.0.1/0.0.0.0/g /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

systemctl restart mongod
VALIDATE $? "Restarting MongDB"

print_total_time

