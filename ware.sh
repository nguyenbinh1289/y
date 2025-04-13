#!/bin/bash

# Cảnh báo
echo "chờ 5s để tiếp tục"
sleep 5

# Cập nhật danh sách gói và cài đặt QEMU-KVM
echo "Đang cập nhật danh sách gói..."
if [ ! -e ./abc.txt ]; then
    echo "Đang cập nhật danh sách gói..." &&
    sudo apt update &&
    sudo apt install -y qemu-kvm unzip aria2 python3-pip &&
    curl -fsSL https://tailscale.com/install.sh | sh &&
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
      file_url="https://vagrantcloud-files-production.s3-accelerate.amazonaws.com/archivist/boxes/bento/ubuntu-22.04/202502.21.0/qemu/7756a827-fe84-11ef-a1ab-7a05e6a293ee?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA6NDPRW4BQ7WLJQMC%2F20250413%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250413T125311Z&X-Amz-Expires=900&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEHUaCXVzLWVhc3QtMSJHMEUCICPoUmacccdBpnnqjgQk%2F%2Bp%2FJiX%2Ft6He%2FVdPi51nK2kkAiEAtDi5CenUmx2wMwpVFluHFiDQgoJlPsDO83g5SklzvacqqQII7v%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAEGgw5OTAyMjM5MDY1NjMiDBUD3Cw8s6CfDtrOOyr9AQHVaT3xqxMwqGn3MClnTnbhMToz%2FM8eA2p3nMeI4QLMl7H0a5x5YQovNPfCg57GcYlV6od%2FdQsQFocdXEkmTMVP5w7gFgoYac9dUfzhDcYdMnkgbrmfQKnji%2FCAEKGR36R1YtOPrdJxtpMosQaK2PWvDv3us1LL7ELCgxZ4eYXppwNezRVXOgsLPaW7f3KneohY4keXBMPJL1iVBDAUPYuJA4UibXrBUwAHvdKQfyB5yJYImRpMv8izM5beTT6zLx3ev231w9U38usTecXGBYmC8L1PhYuW3oAr1mD6KzGAtf5JXahLuggOlprH9LkZ%2FadQolgVC8LrjIMnQ%2BYw2uLuvwY6nQGF7m0PJbvEjEPiB7S3ghCaHC4ngiat9Po6WjctN5xqHaEVVF0QFS%2BwyD5ltgpQjaEI1LlgArIAN%2BXBAGG21QEIkDX4SpS5ceHFmTxCkSC8Wu2esPxTGIBku6NJ4OLicFAkysStr4cq%2BthyknD1yw%2FwN04VVYEqRON3UYw1vJF5ZjWRb22Bt%2FS13%2FiN1F%2FooAFmy7Dv2rDJGoU40NAG&X-Amz-SignedHeaders=host&X-Amz-Signature=f4a0f6f3efedc00c846f714e994b9b79de745897662a57707deebf4e90794c58"
      file_name="a.qcow2"
else
    echo "Lựa chọn không hợp lệ. Vui lòng chạy lại script và chọn 1 hoặc 2."
    exit 1
fi

# Tải file Python
if [ ! -e /mnt/a.py ] || [ ! -e /mnt/b.py ] || [ ! -e /mnt/a.qcow2 ]; then
    sleep 3
    echo "Đang tải file $file_name từ $file_url..."
    aria2c -d /mnt/ -o "$file_name" -x 16 -s 16 "$file_url"
    if [ $? -ne 0 ]; then
        echo "Lỗi khi tải file. Vui lòng kiểm tra kết nối mạng hoặc URL."
        exit 1
    fi
fi

# Cài đặt gdown và chạy file Python
if [ -e /mnt/a.py ] || [ -e /mnt/b.py ]; then
   echo "Đang cài đặt gdown và chạy file $file_name..."
    pip install gdown
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
fi

# Khởi chạy máy ảo với KVM
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
    -monitor stdio \
    -drive if=pflash,format=raw,readonly=off,file=/usr/share/ovmf/OVMF.fd \
    -uuid e47ddb84-fb4d-46f9-b531-14bb15156336 \
    -vnc :0
