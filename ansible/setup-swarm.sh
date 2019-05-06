#!/bin/bash
echo "Criando arquivo hosts ..."

public_subnet=("Public Subnet A" "Public Subnet B" "Public Subnet C")
private_subnet=("Private Subnet A" "Private Subnet B" "Private Subnet C")
for i in {1..3}
    do
        SUBNET=$(aws ec2 --region us-east-1 describe-subnets --filters "Name=tag:Name,Values=${public_subnet[i-1]}" | jq -r '.Subnets[].SubnetId')
        IP=$(aws ec2 --region us-east-1 describe-instances --filters "Name=subnet-id,Values=${SUBNET}" | jq -r '.Reservations[].Instances[].PrivateIpAddress')
        if [ ${i} -eq "1" ]; then
            echo "[docker_swarm_cluster]" > hosts
            echo "MANAGER${i} ansible_ssh_host=${IP}" >> hosts

            echo "" >> hosts

            echo "[docker_swarm_manager]" >> hosts
            echo "MANAGER${i} ansible_ssh_host=${IP}" >> hosts

            echo "docker_swarm_manager_ip: \"${IP}\"" > group_vars/all
            echo "docker_swarm_manager_port: \"2377\"" >> group_vars/all
        else
            echo "MANAGER${i} ansible_ssh_host=${IP}" >> hosts
        fi
done

echo "" >> hosts
echo "[docker_swarm_worker]" >> hosts

for i in {1..3}
    do
        SUBNET=$(aws ec2 --region us-east-1 describe-subnets --filters "Name=tag:Name,Values=${private_subnet[i-1]}" | jq -r '.Subnets[].SubnetId')
        IP=$(aws ec2 --region us-east-1 describe-instances --filters "Name=subnet-id,Values=${SUBNET}" | jq -r '.Reservations[].Instances[].PrivateIpAddress')
        echo "WORKER${i} ansible_ssh_host=${IP}" >> hosts
done

echo "" >> hosts

echo "Iniciando Playbook Ansible ..."
ansible-playbook -i hosts main.yml -s
