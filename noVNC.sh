#INstalling NGROK

sudo apt update && curl -L "https://github.com/nguyenbinh1289/y/raw/main/add.sh"
read -p "NGROk Authtoken: " Token
clear
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && sudo tar -xvf ngrok-v3-stable-linux-amd64.tgz && sudo mv ngrok /usr/local/bin/
clear
#Install novnc

git clone https://github.com/novnc/noVNC.git && ngrok config add-authtoken "$Token"
read -p "Set port cho NGROK;noVNC :" Port
clear
ngrok http "$Port" & ./noVNC/utils/novnc_proxy --listen "$Port"


