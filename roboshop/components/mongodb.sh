#!/bin/bash

COMPONENT="mongodb"
LOGFILE="/tmp/${COMPONENT}.log"
MONGO_REPO="https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo"
SCHEMA_URL="https://github.com/stans-robot-project/mongodb/archive/main.zip"

source components/common.sh         # source will keep all the functions local to the current script that declared in other file.

echo -e "\e[35m ****** ______ $COMPONENT Configuration Is Started ****** ______ \e[0m"

echo -n "Configuring $COMPONENT repo"
curl -s -o /etc/yum.repos.d/mongodb.repo $MONGO_REPO
stat $? 

echo -n "Installing $COMPONENT :"
dnf install -y mongodb-org  &>>  $LOGFILE
stat $? 

echo -n "Enabling $COMPONENT Service :"
systemctl enable mongod     &>>  $LOGFILE
stat $?

echo -n "Enabling $COMPONENT Visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "Starting $COMPONENT Service :"
systemctl start mongod     &>>  $LOGFILE
stat $?

echo -n "Downloading $COMPONENT Schema File : "
curl -s -L -o /tmp/mongodb.zip $SCHEMA_URL  &>>  $LOGFILE
stat $?

echo -n "Extracting $COMPONENT Schema :"
cd /tmp
unzip -o ${COMPONENT}.zip   &>>  $LOGFILE
stat $? 

echo -n "Injecting the schema :"
cd /tmp/mongodb-main   
mongo < catalogue.js    &>>  $LOGFILE
mongo < users.js        &>>  $LOGFILE
stat $? 

echo -e "\e[35m ****** ______ $COMPONENT Configuration Is Completed ****** ______ \e[0m"