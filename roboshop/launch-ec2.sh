#!/bin/bash 

# This script creates EC2 Instaces & the associated DNS Records for the created servers

AMI_ID="ami-0bee47ea953515411"
SGID="sg-009ab1454a519d038"               # Create your own Security Group that allows allows all and then add your SGID 
HOSTEDZONE_ID="Z085783623DWXDG27CQ0U"     # User your private zone id
COMPONENT=$1


if [ -z "$1" ]; then
    echo -e "\e[31m   COMPONENT IS NEEDED: \e[0m"
    echo -e "\e[36m \t\t Example Usage : \e[0m  bash launch-ec2.sh dev ratings"
    exit 1
fi


aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SGID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=\"${COMPONENT}\"}]"
 