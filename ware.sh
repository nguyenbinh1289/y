echo "Do you want to continue? :"

read -p "Yes/No : " user_choice

case $user_choice in
[yY][eE][sS]
  clear
  curl -s -L -o ngNovnc.py "https://raw.githubusercontent.com/nguyenbinh1289/y/main/NGrok&novnc.py"
  python3 ngNovnc.py
case $user_choice in
[nN][oO]
  clear
  exit 1
else
  echo "Error404. chose again"
  curl -s -L -o addNo.sh "https://github.com/nguyenbinh1289/y/raw/main/addNo.sh" && chmod +x addNo.sh
  sudo ./addNo.sh
fi


