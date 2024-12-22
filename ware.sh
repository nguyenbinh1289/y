echo "Do you want to continue? :"

read -p "Yes/No : " user_choice

if [ "$user_choice" -eq Yes ]; then
  clear
  
else
     echo "Error404. Vui lòng chạy lại script."
     exit 1
fi
