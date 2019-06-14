#!/bin/bash
echo "Recive GPG keys"
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
echo "install rvm"
curl -sSL https://get.rvm.io | bash -s stable
echo "Set RVM scripts and Install requirements"
source ~/.rvm/scripts/rvm
rvm requirements
echo "Install Ruby 2.4.1"
rvm install 2.4.1
echo "Set default Ruby version for user"
rvm use 2.4.1 --default
echo "Install Ruby bundler"
gem install bundler -V --no-ri --no-rdoc
echo "Check instalation"
ruby -v && bundle -v