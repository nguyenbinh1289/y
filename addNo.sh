read -p "1.Yes/2.No : " answer
if [ "$answer" -eq 1 ]; then
clear
sudo ./ware.sh
elif [ "$answer" -eq 2]; then
clear
exit 1
fi