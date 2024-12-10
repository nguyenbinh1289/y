import os
import subprocess

os.system("sudo apt install ufw")
os.system("sudo ufw allow 8888")
os.system("npm install -g localtunnel")
os.system("python3 -m pip install notebook")
os.system("git clone https://github.com/epic-miner/fooocus.git")
os.system("lt --port 8888 & python3 -m notebook --allow-root & wget -q -O - https://loca.lt/mytunnelpassword")
