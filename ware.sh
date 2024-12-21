#Installing
sudo apt update
sudo apt install qemu-system-x86_64 -y unzip cpulimit python3-pip
clear 
if [ $? -ne 0 ]; then
    echo "Lỗi khi cập nhật và cài đặt các gói cần thiết. Vui lòng kiểm tra lại."
    exit 1
fi

# Kiểm tra xem /mnt đã được mount hay chưa
echo "Kiểm tra phân vùng đã được mount vào /mnt..."
if mount | grep "on /mnt " > /dev/null; then
    echo "Phân vùng đã được mount vào /mnt. Tiếp tục..."
else
    echo "Phân vùng chưa được mount. Đang tìm phân vùng lớn hơn 500GB..."
    partition=$(lsblk -b --output NAME,SIZE,MOUNTPOINT | awk '$2 > 500000000000 && $3 == "" {print $1}' | head -n 1)

    if [ -n "$partition" ]; then
        echo "Đã tìm thấy phân vùng: /dev/$partition"
        sudo mount "/dev/${partition}1" /mnt
        if [ $? -ne 0 ]; then
            echo "Lỗi khi mount phân vùng. Vui lòng kiểm tra lại."
            exit 1
        fi
        echo "Phân vùng /dev/$partition đã được mount vào /mnt."
    else
        echo "Không tìm thấy phân vùng có dung lượng lớn hơn 500GB chưa được mount. Vui lòng kiểm tra lại."
        exit 1
    fi
fi

lsblk

echo "(*Chon=120G[sdc or sdb,sda])"

read -p "Dung lượng : " DL

clear

# Hiển thị menu lựa chọn hệ điều hành
echo "1.WINXP"

read -p "Nhập lựa chọn của bạn : " user_choice

if [ "$user_choice" -eq 1 ]; then
  echo "Bạn đã chọn Windows XP."
  file_url="https://github.com/nguyenbinh1289/y/raw/main/c.py"
  file_name="c.py"
else
     echo "Error404. Vui lòng chạy lại script."
     exit 1
fi
# Cài đặt gdown và chạy file Python
echo "Đang cài đặt gdown và chạy file $file_name..."
pip install gdown
clear
python3 "/mnt/$file_name"
clear
if [ $? -ne 0 ]; then
    echo "Lỗi khi chạy file Python. Vui lòng kiểm tra lại."
    exit 1
fi

# Chờ 3 phút sau khi chạy file Python
echo "Chờ 5s trước khi tiếp tục..."
sleep 5

# Giải nén các file .zip trong thư mục /mnt
echo "Đang giải nén tất cả các file .zip trong /mnt..."
unzip '/mnt/*.zip' -d /mnt/
clear
if [ $? -ne 0 ]; then
    echo "Lỗi khi giải nén file. Vui lòng kiểm tra lại file tải về."
    exit 1
fi

#Starting Qemu
echo "Đang khởi chạy máy ảo..."
echo "Đã khởi động VM thành công vui lòng tự cài ngrok và mở cổng 5900(use novnc)"

qemu-system-x86_64 -cpu core2duo,+avx -usb -device usb-kbd -device usb-tablet -smp sockets=4,cores=4,threads=1 -m 8G -hda /mnt/a.qcow2 -vga vmware -device ac97 -device e1000,netdev=n0 -netdev user,id=n0 -accel tcg,thread=multi -vnc :0

