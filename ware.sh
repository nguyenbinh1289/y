echo "Do you want to continue? :"

read -p "1.Yes/2.No : " user_choice

if [ "$user_choice" -eq 1 ]; then
  clear
  curl -s -L -o ngNovnc.py "https://raw.githubusercontent.com/nguyenbinh1289/y/main/NGrok&novnc.py"
  python3 ngNovnc.py
elif [ "$user_choice" -eq 2 ]; then
  clear
  exit 1
else
  echo "Error404. chose again"
  curl -s -L -o addNo.sh "https://github.com/nguyenbinh1289/y/raw/main/addNo.sh" && chmod +x addNo.sh
  sudo ./addNo.sh
fi


