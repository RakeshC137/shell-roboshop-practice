#!/bin/bash

source ./common.sh
APP_NAME="catalogue"

check_root
app_setup
nodejs_setup 
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongo repo"

dnf install mongodb-mongosh -y  &>>$LOGS_FILE
VALIDATE $? "Installing mongo db"

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
   mongosh --host mongodb.rakesh.bond </app/db/master-data.js &>>$LOGS_FILE
   VALIDATE $? "Loading products"
else
   echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Schema already loaded $Y SKIPPING $N"
fi

print_total_time