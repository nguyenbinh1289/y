import os
import subprocess

subprocess.run(['wget', 'wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared'])
os.system("python3 -m pip install notebook")
os.system("chmod +x cloudflared")
os.system("sudo mv cloudflared /usr/local/bin/")
os.system("cloudflared tunnel --url localhost:8888 & python3 -m notebook --allow-root")
