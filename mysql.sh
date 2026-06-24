#!/bin/bash

source ./common.sh
APP_NAME="mysql"

check_root

dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "Installing Mysql"

systemctl enable mysqld &>>$LOGS_FILE
systemctl start mysqld  
VALIDATE $? "Enable and Starting Mysql"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setup root password"

print_total_time