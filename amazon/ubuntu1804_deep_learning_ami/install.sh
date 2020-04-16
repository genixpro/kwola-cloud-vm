#!/usr/bin/env bash -e


curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -


sudo apt update -y

sudo apt install ffmpeg chromium-browser nodejs build-essential libcurl4-openssl-dev libxml2-dev mime-support fuse fuse-dbg libssl-dev -y

wget https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo cp chromedriver /usr/bin/
sudo chmod 644 /usr/bin/chromedriver
sudo chmod +x /usr/bin/chromedriver
rm -rf chromedriver
rm -rf chromedriver_linux64.zip

python3 -m venv venv
source venv/bin/activate
pip3 install kwola --upgrade --no-cache


sudo npm install @babel/cli -g
sudo npm install @babel/core -g
sudo npm install babel-plugin-kwola -g
npm install babel-plugin-kwola
rm -rf package-lock.json

chmod +x run_kwola.sh
chmod +x initialize_kwola.sh

git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse
./autogen.sh
./configure
make -j 16
sudo make install
cd ..
sudo rm -rf s3fs-fuse


mkdir kwola_s3_mount


sudo cp kwola.service /etc/systemd/system/kwola.service
sudo systemctl daemon-reload
sudo systemctl enable kwola
sudo systemctl daemon-reload


echo "Installing the SSH Banner for the Server"
sudo cp ssh_banner.txt /etc/banner
sudo su -c 'echo "Banner /etc/banner" >> /etc/ssh/sshd_config'
sudo rm /etc/update-motd.d/00-header
sudo rm /etc/update-motd.d/05-tfheader
sudo rm /etc/update-motd.d/10-uname
sudo systemctl restart sshd

