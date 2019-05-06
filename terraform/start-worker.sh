#!/bin/bash

yum-config-manager --enable epel
yum install -y \
    curl \
    wget \
    unzip \
    python \
    python-devel \
    jq \
    docker
usermod -a -G docker ec2-user
chkconfig docker on

curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

rm -f /etc/localtime
ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
echo -e 'ZONE="America/Sao_Paulo"\nUTC=true' > /etc/sysconfig/clock

export ZONE=`(curl -sL http://169.254.169.254/latest/meta-data/placement/availability-zone | cut -d'-' -f3 | egrep -o "[a-z]+$")`
export EC2_INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`

if [ ${ZONE} == "a" ]; then
    aws ec2 create-tags --region us-east-1 --resources ${EC2_INSTANCE_ID} --tags Key=Name,Value=worker-docker-a
elif [ ${ZONE} == "b" ]; then
    aws ec2 create-tags --region us-east-1 --resources ${EC2_INSTANCE_ID} --tags Key=Name,Value=worker-docker-b
else
    aws ec2 create-tags --region us-east-1 --resources ${EC2_INSTANCE_ID} --tags Key=Name,Value=worker-docker-c
fi
