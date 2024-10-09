#!/bin/bash

# Checks whether you're running this script with sudo or a root user or not.If not, exit the script
ID=$(id -u)
if [ $ID -ne 0 ] ; then 
    echo -e "\e[31m This script is expected to run with sudo or as a root user \e[0m   \n\t Ex:  bash scriptName compName"
    exit 1
fi 

COMPONENT="frontend"
LOGFILE="/tmp/$1.log"

stat() {
    if [ $1 -eq 0 ]; then 
        echo -e "\e[32m Success \e[0m"
    else 
        echo "\e[31m Failure \e[0m"
    fi 
}

echo -e "\e[35m **************** ______ $COMPONENT Configuration Is Started ______  **************** \e[0m"
echo -n "Intalling Nginx Web Server :"
dnf install nginx -y        &>>  $LOGFILE
stat $?

echo -n "Enabling the service :"
systemctl enable nginx      &>>  $LOGFILE
stat $?

echo -n "Downloading the $COMPONENT Component: "
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $? 

echo -n "Performing $COMPONENT Cleanup :"
cd /usr/share/nginx/html 
rm -rf * &>>  $LOGFILE
stat $? 

echo -n "Extracting $COMPONENT :"
unzip /tmp/frontend.zip   &>>  $LOGFILE 
stat $? 

echo -n "Configuring $COMPONENT :"
mv ${COMPONENT}-main/* .   &>>  $LOGFILE
mv static/* .        &>>  $LOGFILE
rm -rf ${COMPONENT}-main README.md    &>>  $LOGFILE  
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Updating Reverse Proxy File: "
    for i in catalogue user cart shipping payment; do 
        sed -i -e "/$i/s/localhost/$i.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
    done
stat $?

echo -n "Retarting the Web Server: "
systemctl restart nginx       &>>  $LOGFILE
stat $?

echo -e "\e[35m ****** ______ $COMPONENT Configuration Is Completed ****** ______ \e[0m"