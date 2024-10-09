#!/bin/bash

# Checks whether you're running this script with sudo or a root user or not.If not, exit the script
ID=$(id -u)
if [ $ID -ne 0 ] ; then 
    echo -e "\e[31m This script is expected to run with sudo or as a root user \e[0m   \n\t Ex:  bash scriptName compName"
    exit 1
fi 

COMPONENT="redis"
LOGFILE="/tmp/$1.log"
REDIS_REPO="https://rpms.remirepo.net/enterprise/remi-release-8.rpm"

stat() {
    if [ $1 -eq 0 ]; then 
        echo -e "\e[32m Success \e[0m"
    else 
        echo "\e[31m Failure \e[0m"
    fi 
}

echo -e "\e[35m ***** ______ $COMPONENT Configuration Is Started ***** ______ \e[0m"

echo -n "Intalling $COMPONENT Repo :"
dnf install  $REDIS_REPO -y &>>  $LOGFILE
stat $? 


echo -n "Enabling $COMPONENT Repo :"
dnf module enable redis:remi-6.2 -y  &>>  $LOGFILE
stat $?

echo -n "Installing $COMPONENT:"
dnf install redis -y    &>>  $LOGFILE
stat $?

echo -n "Enabling $COMPONENT Visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf  
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf 
stat $? 

echo -n "Starting $COMPONENT :"
systemctl enable $COMPONENT  &>>  $LOGFILE
systemctl restart $COMPONENT &>>  $LOGFILE
stat $? 

echo -e "\e[35m ****** ______ $COMPONENT Configuration Is Completed ****** ______ \e[0m"