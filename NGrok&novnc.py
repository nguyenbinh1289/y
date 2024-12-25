import os

link = input("Link proxy :")
os.system("ngrok http {Port} & {link}")
