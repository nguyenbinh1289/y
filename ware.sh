#!/bin/sh

Temp_Dir=/home/username
max_retries=50
timeout=1

echo "Do you want to continue?"

read -p "Yes/No : " user_choice

case $user_choice in
[yY][eE][sS])
  clear
  mkdir -p $Temp_Dir/usr/local/bin
  curl -s -L -o $Temp_Dir/usr/local/bin/ngNovnc.sh "https://raw.githubusercontent.com/nguyenbinh1289/y/main/noVNC.sh" 
  ;;
  [nN][oO])
  clear
  exit 1
  ;;
  *)
  ;;
  esac

if [ ! -e $Temp_Dir/.installed ]; then
python3 "/$Temp_Dir/usr/local/bin/noVNC.sh"
else
echo "Error. Chose again"
sudo ./ware.sh
fi
