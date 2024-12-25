import os

Port = input("Set port cho VNC và NGROK :")
link = input("Link vnc_proxy :")
os.system("ngrok http {Port} & {link_vnc}")
