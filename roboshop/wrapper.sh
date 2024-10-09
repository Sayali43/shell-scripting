#!/bin/bash

export mysql_root_password=$2                     # Export makes sure the variable saves in the system heap memory and then it can be used in other scripts called by it as well
if [ "$1" = "mysql" ]; then
    if [ -z "$mysql_root_password" ]; then
        echo "mysql_root_password is missing"
        exit 8
    fi
fi 

bash components/$1.sh
