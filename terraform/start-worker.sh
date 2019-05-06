#! /bin/bash

yum install -y \
	curl \
	wget \
	unzip \
	python \
	python-devel \
	docker
usermod -a -G docker ec2-user
chkconfig docker on

curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

rm -f /etc/localtime
ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
echo -e 'ZONE="America/Sao_Paulo"\nUTC=true' > /etc/sysconfig/clock

cat > /home/ec2-user/.ssh/id_rsa.pub <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzthtj3e5Psg3BrIUwFyWZTMeVvX5uoGQqoSpwz+QDdLbT8SGMk+qbmTgJsptEa/AA9S8TIIBuRWQ3+QbUBnPv6l7rx8u7Z03vOPxpowrAM3f1jLUsF13sJ8fU5SKDp8mf8X8lzERtoVIwOcmIV8W2SadQKckDQjSIAs45Nie1TNj6ybaAcsd/Y+oQlBpGBTUwn6WboJ2EzH1sLv9QVYT1k+U3snpJ9Bspx6eFWdodtr9EP9Ch3R44nhTL50Un97II+p8/48LMuHjl+FAPLuHbaUT4ZbUBiKk8GBIorim3M5d5zHQ6Qt7vrHCtWdphBKaZPRxZ25FDswWEgyrOyKYJQ== root@94bf75086ba6

EOF

cat > /home/ec2-user/.ssh/id_rsa <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEoAIBAAKCAQEAzthtj3e5Psg3BrIUwFyWZTMeVvX5uoGQqoSpwz+QDdLbT8SG
Mk+qbmTgJsptEa/AA9S8TIIBuRWQ3+QbUBnPv6l7rx8u7Z03vOPxpowrAM3f1jLU
sF13sJ8fU5SKDp8mf8X8lzERtoVIwOcmIV8W2SadQKckDQjSIAs45Nie1TNj6yba
Acsd/Y+oQlBpGBTUwn6WboJ2EzH1sLv9QVYT1k+U3snpJ9Bspx6eFWdodtr9EP9C
h3R44nhTL50Un97II+p8/48LMuHjl+FAPLuHbaUT4ZbUBiKk8GBIorim3M5d5zHQ
6Qt7vrHCtWdphBKaZPRxZ25FDswWEgyrOyKYJQIBIwKCAQBBAjEP1SuXY38CGrYQ
kiCjdnc/5ugWC3ab/c70OIxcHbKkCpCTeB+fCcLKXOBzRd1DCFhv0RZ7/3asxAiV
hHR+ELHX89uMgd5RTvQtB3s6xFxKokLYV+PJy5whlRVyT0adL5iHSe+fw31D8OAZ
HeKcBNJWJebCRJnPjn+YYVZ9hJ1UGvrDZZ+sXfBY7QYmLHF1pIPXyMUtiTw9sWNm
lpwjM1ninl/BwoNR0lr3+oAjUWzj/swC4MuSlKqHTnWbagjDjA6zh3dCgtzxxYmT
5E0JvqSxCW6+GUpVAFDM6GI1nNg04g/0jRJ3tEJzHYOQAy/3Z3Gjqx8eho4iVsi5
WWULAoGBAOzV+RTyEfIntyijOPaRpSKZ47QvlKbwmf1QS6ojJuww848RULTi7Sdb
9rLWRHhqm9snGNr1CuyuGOQsD89SuR0zYzrFVNyz7jb1jpB3gUBLn7uQx1MbPYd+
yZIa03GNp5opITT50MQ8swa7VbRZsGI8kGYDhoYbePrXIbC++MphAoGBAN+VNQRE
6i/IrZonDgHebewPYOGnnYpL40/5O+hMIWVj5y2fUr3FG0ZeFj4qHSnKapjl6juJ
QTME43738LfTAtTfbIfQc+GUDXlD9W5jBsZgGx3Aa6ww8byRrPtBu/zTHHDnQVHl
HMKQwS5dP2+l+vyg1RYsmLkGj7QTecGix4xFAoGADYiR4/CTT6p/fqo9xPJhNS1d
eAK4CYoXbY+PS4z66Ozat7fYueEU3a17z7R48PAmKce4RwawKsgerfPjpXJw+lq1
No7u6ApIIGXNodrxcWNoNpqPDBAvZtQLhLETZZMQ5DzdU3v9TQrIZsjgU3LW4QrG
bDq3Otz/mU4fLqvTs8sCgYBMqC9vLZIfAvmxMfYshsaaE+azxHCHL/YqDE8N0PWB
2RwPpFbh+m/AWsXMK7I6NsV2QDMNGR2rF550rMePe4vxNqjeG5Vx6Z44NI6pgQmj
GaLloQ75NVoyBg9sFomYguUuBiUGIqrGXYQP5XTV0oHwNyR8oZNyoyn0mPaLiERq
mwKBgFORSuFE/akSxLJ9e0o40+ufbxA3ricU4I/tT2vHcwngjqjJA5NBv8BoHvIL
RIeHJDD4KSeftbCpUjaLK8OPW//4yYtiWe4ZF5h5Ef7Z9zQKsCe/MTi7uQyYlozS
iq1nrdxqCZSisSB2UwkRr5R3LKcQoBeiQpH/LQuWQf3rchEo
-----END RSA PRIVATE KEY-----

EOF

chmod 600 /home/ec2-user/.ssh/id_rsa*
chown -R ec2-user. /home/ec2-user/.ssh/id_rsa*

export ZONE=`(curl -sL http://169.254.169.254/latest/meta-data/placement/availability-zone | cut -d'-' -f3 | egrep -o "[a-z]+$")`
export EC2_INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`

if [ ${ZONE} == "a" ]; then
    aws ec2 create-tags --region us-east-1 --resources ${EC2_INSTANCE_ID} --tags Key=Name,Value=worker-docker-a
elif [ ${ZONE} == "b" ]; then
    aws ec2 create-tags --region us-east-1 --resources ${EC2_INSTANCE_ID} --tags Key=Name,Value=worker-docker-b
else
	aws ec2 create-tags --region us-east-1 --resources ${EC2_INSTANCE_ID} --tags Key=Name,Value=worker-docker-c
fi