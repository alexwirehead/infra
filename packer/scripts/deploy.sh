#!/bin/bash
source ~/.rvm/scripts/rvm
echo "Fetch source from git"
git clone https://github.com/Artemmkin/reddit.git ~/reddit
cd ~/reddit
echo "Install dependencies"
bundle install
echo "Start Puma Server"
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
