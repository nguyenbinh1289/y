import os
import subprocess

Authtoken = input("NGORK AUTHTOKEN :")
os.system("wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz")
os.system("tar -xvf ngrok-v3-stable-linux-amd64.tgz")
os.system("sudo mv ngrok /usr/local/bin/")
os.system("python3 -m pip install notebook")
os.system("ngrok config add-authtoken {Authtoken}")
os.system("ngrok http 8888 & python3 -m notebook --allow-root")
