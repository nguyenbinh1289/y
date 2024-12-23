read -p "1.Continue/2.Cancel : " answer
if [ "$answer" -eq 1 ]; then
clear
sudo ./ware.sh
elif [ "$answer" -eq 2]; then
clear
exit 1
else
echo "Error.Chose again!"
sudo ./addNo.sh
