#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="/var/log/shell-script/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
SCRIPT_START_TIME=$(date +%s) 
MONGODB_HOST=mongodb.rakesh.bond
MYSQL_HOST=mysql.rakesh.bond

check_root(){
   if [ $USERID -ne 0 ]; then
      echo -e "$R Run this script as root user $N"
      exit 1
   fi
}

mkdir -p $LOGS_FOLDER

VALIDATE(){
   if [ $1 -ne 0 ]; then
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 $R FAILURE $N"
      exit 1
   else
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 $G SUCCESS $N"
   fi
}

nodejs_setup(){
   dnf module disable nodejs -y &>>$LOGS_FILE
   VALIDATE $? "Disabling nodejs"

   dnf module enable nodejs:20 -y &>>$LOGS_FILE
   VALIDATE $? "Enabling Nodejs 20"

   dnf install nodejs -y &>>$LOGS_FILE
   VALIDATE $? "Installing nodejs 20"

   npm install &>>$LOGS_FILE
   VALIDATE $? "Installing Dependencies"
}

java_setup(){
   dnf install maven -y &>>$LOGS_FILE
   VALIDATE $? "Installing maven"

   cd /app 
   mvn clean package &>>$LOGS_FILE
   VALIDATE $? "Building $APP_NAME"

   mv target/shipping-1.0.jar shipping.jar 
   VALIDATE $? "Renaming APP_NAME"
}

python_setup(){
   dnf install python3 gcc python3-devel -y &>>$LOGS_FILE
   VALIDATE $? "Installing python"

   cd /app 
   pip3 install -r requirements.txt &>>$LOGS_FILE
   VALIDATE $? "Installing dependencies"
}

app_setup(){
   id roboshop &>>$LOGS_FILE
   if [ $? -eq 0 ]; then
     echo -e "User already exists $Y SKIPPING $N" &>>$LOGS_FILE
   else
     useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
     VALIDATE $? "Adding system User"
   fi

   mkdir -p /app 
   VALIDATE $? "Creating App Directory"

   curl -o /tmp/$APP_NAME.zip https://roboshop-artifacts.s3.amazonaws.com/$APP_NAME-v3.zip &>>$LOGS_FILE
   VALIDATE $? "Downloading $APP_NAME code"

   rm -rf /app/*
   VALIDATE $? "removing existing files"

   cd /app 
   unzip /tmp/$APP_NAME.zip &>>$LOGS_FILE
   VALIDATE $? "Unzipping code in App directory"
}

systemd_setup(){
   cp $SCRIPT_DIR/$APP_NAME.service /etc/systemd/system/$APP_NAME.service
   VALIDATE $? "Created systemctl repo"

   systemctl daemon-reload
   VALIDATE $? "Reloading daemon"

   systemctl enable $APP_NAME &>>$LOGS_FILE
   systemctl start $APP_NAME  
   VALIDATE $? "Enabling and starting"
}

app_restart(){
   systemctl restart $APP_NAME
   VALIDATE $? "Restarting $app_name"
}

print_total_time(){
   SCRIPT_END_TIME=$(date +%s) 
   TOTAL_TIME=$(( $SCRIPT_END_TIME - $SCRIPT_START_TIME ))
   echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script executed in: $G $TOTAL_TIME $N" | tee -a $LOG_FILE
}





