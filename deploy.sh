#!/bin/bash
echo "Fetch source from git"
git clone https://github.com/Artemmkin/reddit.git && cd reddit && bundle install
echo "Start Puma Server"
puma -p 80 -d
