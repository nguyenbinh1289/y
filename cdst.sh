#!/bin/bash

echo "1.NoFastBoot"
echo "2.FastBoot"
read -p "Chọn Phiên Bản Phù Hợp(1or2): " Ver
  if [ "$Ver" -eq 1 ]; then
    echo "You chose 1.NoFastBoot"
  elif [ "$Ver" -eq 2 ]; then
    echo "You chose 2.FastBoot"
    curl -s -o "FastBoot.sh" "https://github.com/nguyenbinh1289/y/raw/main/ware.sh"
    sudo ./FastBoot.sh
    exit
  else
     echo "Please Try Again!"
echo "Chờ 5s trước khi tiếp tục"
sleep 5
  fi

max_tries=50
# Cập nhật danh sách gói và cài đặt QEMU-KVM
echo "Đang cập nhật danh sách gói..."
sudo apt update
sudo apt install -y qemu-kvm unzip cpulimit python3-pip
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

if [ ! -e /mnt/driver.iso ]; then
   echo "Waiting!"
   sleep 1
   if ! wget -O "/mnt/driver.iso" "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.266-1/virtio-win-0.1.266.iso"; then
      echo "Downloading Driver Failed!"
      exit 1
   fi
fi

# Hiển thị menu lựa chọn hệ điều hành
echo "Chọn hệ điều hành để chạy VM:"
echo "3.SL11(24H2)/FastBoot*"
echo "4.ForWork/FastBoot*"

read -p "Nhập lựa chọn của bạn : " user_choice

if [ "$user_choice" -eq 3 ]; then
    if [ ! -e /mnt/a.iso ]; then
       echo "Downloading..."
       if ! wget -O "/mnt/a.iso" "https://pixeldrain.com/api/file/1stNM9qc?download"; then
          echo "Download failed!"
          exit 1
       fi
    fi

# Kiểm tra file ISO có thực sự tải được không
if [ ! -s /mnt/a.iso ]; then
    echo "Error: ISO file is empty or corrupted!"
    rm -f "/mnt/a.iso"
    exit 1
fi
  
elif [ "$user_choice" -eq 4 ]; then
    if [ ! -e /workspaces/action/gdown!.py ]; then
       echo "Downloading..."
       if ! wget -O "gdown!.py" "https://github.com/nguyenbinh1289/y/raw/main/c.py"; then
          echo "Download Failed!"
          exit 1
       fi
    fi

    # Kiểm tra file ISO có thực sự tải được không
    pip install gdown && python3 gdown!.py
    if [ ! -s /mnt/winwork.iso ]; then
       echo "Error: ISO file is empty or corrupted!"
       rm -f "/mnt/winwork.iso"
       exit 1
    fi
      
#Starting Qemu
sleep 3
echo "Đang khởi chạy máy ảo..."
echo "Đã khởi động VM thành công vui lòng tự cài ngrok và mở cổng 5900(use novnc)"

sudo kvm \
-cpu host,+topoext,hv_relaxed,hv_spinlocks=0x1fff,hv-passthrough,+pae,+nx,kvm=on,+svm \
-smp sockets=1,cores=4,threads=2 \
-M q35,usb=on \
-device usb-tablet \
-m 8G \
-device virtio-balloon-pci \
-vga virtio \
-net nic,netdev=n0,model=virtio-net-pci \
-netdev user,id=n0,hostfwd=tcp::3389-:3389 \
-boot c \
-device virtio-serial-pci \
-device virtio-rng-pci \
-enable-kvm \
-drive file=/dev/"$DL",format=raw,if=none,id=nvme0 \
-device nvme,drive=nvme0,serial=deadbeaf1,num_queues=8 \
-monitor stdio \
-drive if=pflash,format=raw,readonly=off,file=/usr/share/ovmf/OVMF.fd \
-uuid e47ddb84-fb4d-46f9-b531-14bb15156336 \
-drive file=/mnt/driver.iso,media=cdrom \
-drive file=/mnt/winwork.iso,media=cdrom \
-vnc :0
exit
fi
