#/bin/bash

# This is a file to host all the COMMON PATTERN's or the common functions.
# This can be imported in any of the scripts with the help of source

LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"
APPUSER_DIR="/home/${APPUSER}/${COMPONENT}"

ID=$(id -u)
if [ $ID -ne 0 ] ; then 
    echo -e "\e[31m This script is expected to run with sudo or as a root user \e[0m   \n\t Ex:  bash scriptName compName"
    exit 1
fi

stat() {
    if [ $1 -eq 0 ]; then 
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
    fi 
}

# Declaring Create User Function
CREATE_USER() {
    echo -n "Creating $APPUSER user account: "
    id $APPUSER     &>>  $LOGFILE
    if [ $? -ne 0 ]; then 
        useradd $APPUSER
        stat $? 
    else 
        echo -e "\e[35m SKIPPING \e[0m"
    fi 
}

DOWNLOAD_AND_EXTRACT() {

    echo -n "Performing $COMPONENT Cleanup :"
    rm -rf ${APPUSER_DIR}  || true  &>>  $LOGFILE
    stat $? 

    echo -n "Downloading the $COMPONENT Component: "
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $? 

    echo -n "Extracting $COMPONENT :"
    cd /home/roboshop
    unzip -o /tmp/${COMPONENT}.zip  &>>  $LOGFILE
    mv /home/${APPUSER}/${COMPONENT}-main /home/${APPUSER}/${COMPONENT}
    stat $? 
}

CONFIG_SVC() {
    echo -n "Configuring Permissions :"
    chown -R ${APPUSER}:${APPUSER} ${APPUSER_DIR}      &>>  $LOGFILE
    stat $? 

    echo -n "Configuring $COMPONENT Service: "
    sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' ${APPUSER_DIR}/systemd.service
    mv ${APPUSER_DIR}/systemd.service   /etc/systemd/system/${COMPONENT}.service
    stat $? 
}