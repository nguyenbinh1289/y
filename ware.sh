echo "Do you want to continue? :"

read -p "1.Yes/2.No : " user_choice

if [ "$user_choice" -eq 1 ]; then
  clear
  wget -O "ngNovnc.py" "https://raw.githubusercontent.com/nguyenbinh1289/y/main/NGrok&novnc.py"
  clear
  python3 novncng.py
elif [ "$user_choice" -eq 2 ]; then
  clear
  exit 1
else
  echo "Error404. chose again"
fi


