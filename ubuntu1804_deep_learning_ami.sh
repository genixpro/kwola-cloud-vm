

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -


sudo apt update -y

sudo apt install ffmpeg chromium-browser nodejs build-essential -y

wget https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo cp chromedriver /usr/bin/

python3 -m venv venv
source venv/bin/activate
pip3 install kwola


sudo npm install @babel/cli -g
sudo npm install @babel/core -g

sudo npm install babel-plugin-kwola -g

