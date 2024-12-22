import os

Token = input("NGROK Authtoken :")
print ("Installing NGROK...")
os.system("wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz")
os.system("sudo tar -xvf ngrok-v3-stable-linux-amd64.tgz")
os.system("sudo mv ngrok /usr/local/bin/")
os.system("clear")
print("Installing noVNC...")
os.system("git clone https://github.com/novnc/noVNC.git")
os.system("ngrok config add-authtoken {Token}")
Port = input("Set port cho VNC :")
Http = input("Set port cho NGROK :")
print ("code for vnc_proxy :")
print ("./noVNC/utils/novnc_proxy --listen {Your Port}")
print ("!Lưu ý: Nhập lệnh vnc ở trang khác.")





