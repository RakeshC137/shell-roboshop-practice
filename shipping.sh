#!/bin/bash

source ./common.sh

APP_NAME="shipping"
check_root
app_setup
java_setup
systemd_setup

dnf install mysql -y &>>$LOGS_FILE
VALIDATE $? "Installing Mysql"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOGS_FILE
if [ $? -ne 0 ]; then
   mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOGS_FILE
   mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOGS_FILE
   mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOGS_FILE
   VALIDATE $? "Loaded data into MySQL" 
else
   echo -e "Schema already loaded $Y Skipping $N"
fi

print_total_time