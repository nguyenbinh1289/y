import os

Port = input("Set port cho VNC and NGROK")
Link = input("Link proxy :")
os.system("ngrok http {Port} & {link}")
