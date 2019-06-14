#!/bin/bash
echo "Fetch source from git"
git clone https://github.com/Artemmkin/reddit.git ~/reddit
cd reddit
echo "Install dependencies"
bundle install
echo "Start Puma Server"
puma -p 80 -d
