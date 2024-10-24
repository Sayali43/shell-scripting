#!/bin/bash 

# This script creates EC2 Instaces & the associated DNS Records for the created servers

AMI_ID="ami-0bee47ea953515411"
SGID="sg-009ab1454a519d038"   # Your Security Group ID
HOSTEDZONE_ID="Z055763515QS3B0HRIR6I"  # Your Route 53 Private Zone ID
COLOR="\e[35m"
NOCOLOR="\e[0m"

COMPONENT=$1
ENV=$2  # Ensure ENV is passed as the second argument

if [ -z "$COMPONENT" ] || [ -z "$ENV" ]; then
    echo -e "\e[31m   COMPONENT and ENVIRONMENT NAMES ARE NEEDED: \e[0m"
    echo -e "\e[36m \t\t Example Usage : \e[0m  bash launch-ec2.sh dev ratings"
    exit 1
fi 

# Launch the EC2 instance and get the private IP
PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SGID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}-${ENV}}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')

if [ -z "$PRIVATE_IP" ]; then
    echo -e "\e[31mError: Unable to retrieve Private IP. Check EC2 instance creation.\e[0m"
    exit 1
fi

echo -e "___ ${COLOR}${COMPONENT}-${ENV} Server Created and here is the IP ADDRESS: $PRIVATE_IP ${NOCOLOR}___"

# Generate the DNS JSON file
echo "Creating r53 json file with component name and IP address:"
sed -e "s/IPADDRESS/${PRIVATE_IP}/g" -e "s/COMPONENT/${COMPONENT}-${ENV}/g" route53.json > /tmp/dns.json

echo "Generated DNS JSON:"
cat /tmp/dns.json

# Create DNS record
echo -e "___ ${COLOR}Creating DNS Record for ${COMPONENT}-${ENV} ${NOCOLOR} ___"
aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONE_ID --change-batch file:///tmp/dns.json
