import os

Port = input("Set port cho VNC and NGROK :")
Link_vnc:  = "Link_vnc"
os.system("ngrok http {Port} & {Link_vnc}")
