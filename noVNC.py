import os
import subprocess

Token = ("NGROK Authtoken :")
print ("Installing NGROK")
os.system("wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz")
os.system("clear")
os.system("sudo tar -xvf ngrok-v3-stable-linux-amd64.tgz")
os.system("clear")
os.system("sudo mv ngrok /usr/local/bin/")
os.system("clear")
os.system("git clone https://github.com/novnc/noVNC.git")
os.system("clear")
os.system("ngrok config add-authtoken {Token}")
os.system("ngrok http 8888 && ./noVNC/utils/novnc_proxy")
