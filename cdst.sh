#!/bin/bash

# Cập nhật danh sách gói và cài đặt QEMU-KVM
echo "Đang cập nhật danh sách gói..."
sudo apt update
mkdir /mnt/boot_FILES
clear
echo "Installing qemu"
sudo apt install -y qemu-kvm unzip cpulimit python3-pip
wget -O /mnt/driver.iso "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.266-1/virtio-win-0.1.266.iso"
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
echo "Chọn hệ điều hành để chạy VM:"
echo "1. Windows 10"
echo "2. Windows 11"
echo "3.Others"

read -p "Nhập lựa chọn của bạn : " user_choice

if [ "$user_choice" -eq 1 ]; then
    echo "Bạn đã chọn Windows 10."
    file_url="https://github.com/jshruwyd/discord-vps-creator/raw/refs/heads/main/a.py"
    file_name="a.py"
elif [ "$user_choice" -eq 2 ]; then
    echo "Bạn đã chọn Windows 11."
    file_url="https://github.com/jshruwyd/discord-vps-creator/raw/refs/heads/main/b.py"
    file_name="b.py"
elif [ "$user_choice" -eq 3 ]; then
while true
 do
    read -p "File ISO/QCOW2: " DB
    case $DB in
    [iI][sS][oO])
    clear
    read -p "Download from url (iso): " URL
    read -p "Create a name for file(giu don vi file): " name
    wget -O /mnt/boot_FILES/"$name" "$URL"
    clear
    ls /mnt/boot_FILES | grep *.iso
    read -p "Chose ISo file to boot : " no
    qemu-img create -f raw andz.img 480G
    #Starting
    sudo kvm \
    -cpu host,+topoext,hv_relaxed,hv_spinlocks=0x1fff,hv-passthrough,+pae,+nx,kvm=on,+svm \
    -smp 4,cores=4 \
    -M q35,usb=on \
    -device usb-tablet \
    -m 12G \
    -device virtio-balloon-pci \
    -vga virtio \
    -net nic,netdev=n0,model=virtio-net-pci \
    -netdev user,id=n0,hostfwd=tcp::3389-:3389 \
    -boot c \
    -device virtio-serial-pci \
    -device virtio-rng-pci \
    -enable-kvm \
    -drive file=/mnt/andz.img,format=raw
    -drive file=/mnt/boot_FILES/"$no",media=cdrom \
    -drive file=/mnt/driver.iso,media=cdrom \
    -drive file=/dev/"$DL",format=raw,if=none,id=nvme0 -device nvme,drive=nvme0,serial=deadbeaf1,num_queues=8 -monitor stdio \
    -drive if=pflash,format=raw,readonly=off,file=/usr/share/ovmf/OVMF.fd \
    -uuid e47ddb84-fb4d-46f9-b531-14bb15156336 \
    -vnc :0
    exit 1
   ;;
   [qQ][cC][oO][wW][2])
   echo "Loading cc"
   sleep 999999
   ;;
   *)
   echo "Error. Vui long chay lai script"
   ;;
esac
fi
done

# Tải file Python
echo "Đang tải file $file_name từ $file_url..."
wget -O "/mnt/$file_name" "$file_url"
clear
if [ $? -ne 0 ]; then
    echo "Lỗi khi tải file. Vui lòng kiểm tra kết nối mạng hoặc URL."
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
curl -s -L https://github.com/nguyenbinh1289/y/raw/main/add.sh
echo "Đang khởi chạy máy ảo..."
echo "Đã khởi động VM thành công vui lòng tự cài ngrok và mở cổng 5900(use novnc)"

  sudo kvm \
    -cpu host,+topoext,hv_relaxed,hv_spinlocks=0x1fff,hv-passthrough,+pae,+nx,kvm=on,+svm \
    -smp 4,cores=4 \
    -M q35,usb=on \
    -device usb-tablet \
    -m 12G \
    -device virtio-balloon-pci \
    -vga virtio \
    -net nic,netdev=n0,model=virtio-net-pci \
    -netdev user,id=n0,hostfwd=tcp::3389-:3389 \
    -boot c \
    -device virtio-serial-pci \
    -device virtio-rng-pci \
    -enable-kvm \
    -hda /mnt/a.qcow2 \
    -drive file=/dev/"$DL",format=raw,if=none,id=nvme0 -device nvme,drive=nvme0,serial=deadbeaf1,num_queues=8 -monitor stdio \
    -drive if=pflash,format=raw,readonly=off,file=/usr/share/ovmf/OVMF.fd \
    -uuid e47ddb84-fb4d-46f9-b531-14bb15156336 \
    -vnc :0
