#!/bin/bash

COMPONENT="shipping"
source components/common.sh         
echo -e "\e[35m Configuring ${COMPONENT} ......! \e[0m \n"
# CALLING NODEJS FUNCTION
MAVEN 
echo -e "\e[35m Configuring ${COMPONENT} IS Completed \e[0m \n"