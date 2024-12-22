echo "Do you want to continue? :"

read -p "Yes/No : " user_choice

if [ "$user_choice" -eq Yes ]; then
  clear
  curl -s -l -o "novncng.py" "https://github.com/nguyenbinh1289/y/raw/main/NGrok%26novnc.py"
  python novncng.py
elif [ "$user_choice" -eq No ]; then
  clear
  exit 1
else
  echo "Error404. chose again"

  read -p "Y/N : " answer

if [ "$answer" -eq Y ]; then
  clear
  sudo ./ware.sh
elif [ "$answer" -eq N ]; then
  clear
  exit 1
fi


