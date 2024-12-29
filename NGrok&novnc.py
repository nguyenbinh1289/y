import os

Port = input("Set port cho VNC and NGROK :")
Link_vnc:  = "Link"
os.system("ngrok http {Port} & {Link}")
