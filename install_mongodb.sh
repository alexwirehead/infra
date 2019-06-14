#!/bin/bash
echo "Recive Mongo GPG key"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "Add MongoDB Repo"
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
echo "Install MongoDB"
sudo apt-get update && sudo apt-get install -y mongodb-org
echo "Start Mongo"
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod