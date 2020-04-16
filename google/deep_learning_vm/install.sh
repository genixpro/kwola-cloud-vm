

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -


sudo apt update -y

sudo apt install ffmpeg chromium nodejs build-essential libcurl4-openssl-dev libxml2-dev mime-support fuse fuse-dbg libssl-dev -y

wget https://chromedriver.storage.googleapis.com/73.0.3683.68/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo cp chromedriver /usr/bin/
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


mkdir kwola_gcs_mount


sudo cp kwola.service /etc/systemd/system/kwola.service
sudo systemctl daemon-reload
sudo systemctl enable kwola
sudo systemctl daemon-reload

