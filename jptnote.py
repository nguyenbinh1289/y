import os
import subprocess

Authtoken = input("NGORK AUTHTOKEN :")
subprocess.run(['wget', 'wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrtgzok-v3-stable-linux-amd64'])
os.system("tar -xvf ngrok-v3-stable-linux-amd64.tgz")
os.system("sudo mv ngrok /usr/local/bin/")
os.system("python3 -m pip install notebook")
os.system("ngrok config add-authtoken {Authtoken}")
os.system("ngrok http 8888 & python3 -m notebook --allow-root")
