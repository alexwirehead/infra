#!/bin/bash
set -e
sudo yum update -y
sudo yum install -y epel-release ansible git wget unzip python-pip
sudo wget https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip -P /tmp
cd /tmp && sudo unzip terraform_0.12.3_linux_amd64.zip
sudo chmod +x terraform && sudo cp terraform /usr/bin
sudo wget https://releases.hashicorp.com/packer/1.4.2/packer_1.4.2_linux_amd64.zip -P /tmp
cd /tmp && sudo unzip packer_1.4.2_linux_amd64.zip
sudo chmod +x packer && sudo cp packer /usr/bin
packer -v && terraform -v
git config --global user.email "alex@wirehead.pro"
git config --global user.name "alexwirehead"
echo "cleanup tmp"
shopt -s extglob
cd /tmp/ && ls -A1 -- *@(packer|terraform)* | sudo xargs rm -f