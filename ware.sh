#!/bin/bash

# Cập nhật danh sách gói và cài đặt QEMU-KVM
echo "Đang cập nhật danh sách gói..."
if [ ! -e ./abc.txt ]; then
    echo "Đang cập nhật danh sách gói..." &&
    sudo apt update &&
    sudo apt install -y qemu-kvm p7zip-full aria2 python3-pip &&
    git clone https://github.com/novnc/noVNC.git &&
    touch abc.txt ||
    { echo "Đã có lỗi xảy ra trong quá trình cài đặt."; exit 1; }
fi

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

# Ổ Cài
DL=$(lsblk -b --output NAME,SIZE,MOUNTPOINT | awk '$2 > 100000000000 && $2 < 150000000000 {print $1}' | head -n 1)

# Hiển thị menu lựa chọn hệ điều hành
echo "Chọn hệ điều hành để chạy VM:"
echo "1. Windows 10/FastBoot"
echo "2. Windows 11/FastBoot"
echo "3.Ubuntu 22.04 -Cấp Tốc"

read -p "Nhập lựa chọn của bạn: " user_choice

if [ "$user_choice" -eq 1 ]; then
    echo "Bạn đã chọn Windows 10."
    file_url="https://github.com/jshruwyd/discord-vps-creator/raw/refs/heads/main/a.py"
    file_name="a.py"
elif [ "$user_choice" -eq 2 ]; then
    echo "Bạn đã chọn Windows 11."
    file_url="https://github.com/jshruwyd/discord-vps-creator/raw/refs/heads/main/b.py"
    file_name="b.py"
elif [ "$user_choice" -eq 3 ]; then
      file_url="https://api.cloud.hashicorp.com/vagrant-archivist/v1/object/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrZXkiOiJCb3hDYWxpL051bGwvMi4wLjIuNS8yLjAuMi41LzM3MTg2Y2Y5LTE5YjktMTFmMC04YTI5LWVhNDA3MGMyZmNmMSIsIm1vZGUiOiJyIiwiZmlsZW5hbWUiOiJOdWxsXzIuMC4yLjVfMi4wLjIuNV9hbWQ2NC5ib3gifQ.YDQzZUTgisfGvYWIAdAJun5RoeMUReNmqsyF7_m2rpI"
      file_name="kali.7z"
else
    echo "Lựa chọn không hợp lệ. Vui lòng chạy lại script và chọn 1 hoặc 2."
    exit 1
fi

# Tải file Python và Vân vân
if [ ! -e /mnt/"$file_name" ]; then
    sleep 3
    echo "Đang tải file $file_name từ $file_url..."
    aria2c -d /mnt/ -o "$file_name" -x 16 -s 16 "$file_url"
    if [ $? -ne 0 ]; then
        echo "Lỗi khi tải file. Vui lòng kiểm tra kết nối mạng hoặc URL."
        exit 1
    fi
fi

# Cài đặt gdown và chạy file Python
if [[ "$file_name" == *.py ]]; then
   echo "Đang cài đặt gdown và chạy file $file_name..."
    pip install gdown
   python3 "/mnt/$file_name"
   clear
    if [ $? -ne 0 ]; then
        echo "Lỗi khi chạy file Python. Vui lòng kiểm tra lại."
        exit 1
    fi
fi

      # Giải nén các file .zip trong thư mục /mnt
       echo "Đang giải nén tất cả các file .zip trong /mnt..."
        7z x /mnt/*.zip -o /mnt/ || 7z x /mnt/*.7z -o /mnt/
       clear
        if [ $? -ne 0 ]; then
            echo "Lỗi khi giải nén file. Vui lòng kiểm tra lại file tải về."
            exit 1
        fi
# Khởi chạy máy ảo với KVM
    mv /mnt/kali-linux-2025.1a-qemu-amd64.qcow2 /mnt/a.qcow2
if compgen -G "/mnt/*.qcow2" > /dev/null; then
   echo "Đang khởi chạy máy ảo..."
   echo "Đã khởi động VM thành công vui lòng tự cài ngrok và mở cổng 5900"
    sudo kvm \
    -cpu host,+topoext,hv_relaxed,hv_spinlocks=0x1fff,hv-passthrough,+pae,+nx,kvm=on,+svm \
    -smp sockets=1,cores=2,threads=2 \
    -M q35,usb=on \
    -device usb-tablet \
    -m 10G \
    -device virtio-balloon-pci \
    -vga virtio \
    -net nic,netdev=n0,model=virtio-net-pci \
    -netdev user,id=n0,hostfwd=tcp::3389-:3389 \
    -boot c \
    -device virtio-serial-pci \
    -device virtio-rng-pci \
    -enable-kvm \
    -drive file=/mnt/a.qcow2 \
    -drive file=/dev/"$DL",format=raw,if=none,id=nvme0 \
    -device nvme,drive=nvme0,serial=deadbeaf1,num_queues=8 \
    -daemonize \
    -soundhw hda \
    -drive if=pflash,format=raw,readonly=off,file=/usr/share/ovmf/OVMF.fd \
    -uuid e47ddb84-fb4d-46f9-b531-14bb15156336 \
    -vnc :0
       if [ -e ./noVNC ]; then
           ./noVNC/utils/novnc_proxy --listen 5924
       fi
fi
