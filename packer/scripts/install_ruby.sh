#!/bin/bash
echo "Fetch GPG keys"
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
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