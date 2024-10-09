#!/bin/bash

COMPONENT="user"
source components/common.sh         # source will keep all the functions local to the current script that declared in other file.
echo -e "\e[35m Configuring ${COMPONENT} ......! \e[0m \n"
# CALLING NODEJS FUNCTION
NODEJS 
echo -e "\e[35m Configuring ${COMPONENT} IS Completed \e[0m \n"