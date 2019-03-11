#!/usr/bin/env bash

sudo apt update
sudo apt install -y bsdtar unzip
# installing docker and docker compose
# sudo snap install docker
curl -fsSL https://get.docker.com | bash
sudo apt install -y docker-compose


curl -sSL 'https://github.com/SamuraiWTF/samuraiwtf/archive/master.zip' | bsdtar -xvf - --strip-components=1  -C "/tmp" 1> /dev/null

mkdir -p ~vagrant/Downloads

sed -i 's/samurai/vagrant/g' /tmp/install/userenv_bootstrap.sh
sed -i 's/.*apt-get.*//g' /tmp/install/userenv_bootstrap.sh
sed -i 's/.*feh.*//g' /tmp/install/userenv_bootstrap.sh

sudo bash /tmp/install/userenv_bootstrap.sh
sudo rm -f /etc/apt/sources.list.d/google-chrome.list

sudo apt-get update

sed -i 's/chown samurai:samurai/chown vagrant:vagrant/g' /tmp/install/target_bootstrap.sh
sudo bash /tmp/install/target_bootstrap.sh

sed -i 's/samurai/vagrant/g' /tmp/install/local_targets.sh
sudo bash /tmp/install/local_targets.sh

sudo rm -rf ~vagrant/Downloads bookmarks.html ~vagrant/.bash_profile
