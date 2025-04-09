#!/bin/bash

echo "1.NoFastBoot"
echo "2.FastBoot"
read -p "Chọn Phiên Bản Phù Hợp(1or2): " Ver
  if [ "$Ver" -eq 1 ]; then
      echo "You chose 1.NoFastBoot"
      sleep 3
  elif [ "$Ver" -eq 2 ]; then
       echo "You chose 2.FastBoot"
       sleep 3
       curl -s -o "FastBoot.sh" "https://github.com/nguyenbinh1289/y/raw/main/ware.sh"
       sudo ./FastBoot.sh
       exit
  else
     echo "Please Try Again!"
     sleep 10
  fi

SPICE_PORT=5924
max_tries=50
# Cập nhật danh sách gói và cài đặt QEMU-KVM
if [ ! -e ./abc.txt ]; then
    echo "Đang cập nhật danh sách gói..."
    if ! sudo apt update; then
        echo "Update Failed!"
        exit 1
    elif ! sudo apt install -y qemu-kvm unzip aria2 python3-pip; then
          echo "Installing FAiled!"
          exit 1
    elif ! curl -fsSL https://tailscale.com/install.sh | sh; then
          echo "Set Up For Remote Failed!"
          exit 1
    touch abc.txt
fi
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

#Ổ cài
DL=$(lsblk -b --output NAME,SIZE,MOUNTPOINT | awk '$2 > 100000000000 && $2 < 150000000000 {print $1}' | head -n 1)
if [ ! -e /mnt/disk.img ]; then
    echo "Creating Disk..."
    if ! qemu-img create -f raw /mnt/disk.img 445G; then
        echo "Creating Disk Failed!"
        sudo rm -rf /mnt/disk.img
        exit 1
    fi
fi
       
# Hiển thị menu lựa chọn hệ điều hành
echo "Chọn loại hệ điều hành để chạy VM:"
echo "1.Linux"
echo "2.Windows"
read -p "Nhập lựa chọn của bạn : " user_choice

if [ "$user_choice" -eq 1 ]; then
   clear
   echo "Chọn Hệ Điều Hành Phù Hợp:"
   echo "1.Linux-Mint"
   echo "2.Debian"
   echo "3.MX Linux"
   echo "4.Arch Linux"
   read -p "Nhập lựa chọn của bạn : " HDH
   if [ "$HDH" -eq 1 ]; then
     if [ ! -e /mnt/a.iso ]; then
        echo "Downloading..."
        if ! aria2c -d /mnt/ -o "a.iso" -x 16 -s 16 "https://mirror.rackspace.com/linuxmint/iso/stable/21.3/linuxmint-21.3-xfce-64bit.iso"; then
           echo "Download failed!"
           sudo rm -rf /mnt/a.iso
           exit 1
        fi
     fi
 elif [ "$HDH" -eq 2 ]; then
       if [ ! -e /mnt/a.iso ]; then
          echo "Downloading..."
          if ! aria2c -d /mnt/ -o "a.iso" -x 16 -s 16 "https://saimei.ftp.acc.umu.se/debian-cd/current/amd64/iso-cd/debian-12.10.0-amd64-netinst.iso"; then
             echo "Download failed!"
             sudo rm -rf /mnt/a.iso
             exit 1
          fi
       fi
 elif [ "$HDH" -eq 3 ]; then
      if [ ! -e /mnt/a.iso ]; then
          echo "Downloading..."
          if ! aria2c -d /mnt/ -o "a.iso" -x 16 -s 16 "https://www.dropbox.com/scl/fi/hcqyyt629d8tmxqy3vj80/MX-23.1_x64.iso?rlkey=ez6v1tl2atjihu1nzy74d2xj4&st=wy2wo60e&dl=1"; then
             echo "Download failed!"
             sudo rm -rf /mnt/a.iso
             exit 1
          fi
      fi
 elif [ "$HDH" -eq 4 ]; then
      if [ ! -e /mnt/a.iso ]; then
          echo "Downloading..."
          if ! aria2c -d /mnt/ -o "a.iso" -x 16 -s 16 "https://mirror.freedif.org/archlinux/iso/2025.04.01/archlinux-x86_64.iso"; then
             echo "Download failed!"
             sudo rm -rf /mnt/a.iso
             exit 1
          fi
      fi
             # Kiểm tra file ISO có thực sự tải được không
                      if [ ! -s /mnt/a.iso ]; then
                          echo "Error: ISO file is empty or corrupted!"
                          sudo rm -f "/mnt/a.iso"
                          exit 1
                      fi  
   fi
       # Chạy Qemu-Kvm Linux distro
       sleep 3
       clear
        echo "Đang khởi chạy máy ảo..."
        echo "Đã khởi động VM thành công"
         sudo kvm \
      -daemonize \
      -cpu host,+topoext,hv_relaxed,hv_spinlocks=0x1fff,hv-passthrough,+pae,+nx,kvm=on,+svm \
      -smp sockets=1,cores=2,threads=2 \
      -M q35,usb=on \
      -device usb-tablet \
      -m 11G \
      -device virtio-balloon-pci \
      -vga virtio \
      -net nic,netdev=n0,model=virtio-net-pci \
      -netdev user,id=n0,hostfwd=tcp::3389-:3389 \
      -boot c \
      -device virtio-serial-pci \
      -device virtio-rng-pci \
      -enable-kvm \
      -drive file=/dev/"$DL",format=raw,if=none,id=nvme0 \
      -drive file=/mnt/disk.img,format=raw,if=none,id=nvme1 \
      -device nvme,drive=nvme0,serial=deadbeaf1,num_queues=4 \
      -device nvme,drive=nvme1,serial=deadbeaf2,num_queues=4 \
      -drive if=pflash,format=raw,readonly=off,file=/usr/share/ovmf/OVMF.fd \
      -uuid e47ddb84-fb4d-46f9-b531-14bb15156336 \
      -drive file=/mnt/a.iso,media=cdrom \
      -device intel-hda \
      -device hda-duplex \
      -chardev spicevmc,id=vdagent,name=vdagent \
      -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
      -spice port=${SPICE_PORT},disable-ticketing
          if [ ! -e ./tailscaled.state ]; then
              if ! sudo tailscaled --state=tailscaled.state; then
                  echo "Nope..."
                  exit 1
              fi
          fi
      exit
fi

  if [ "$user_choice" -eq 2 ]; then
     echo "Chọn Hệ Điều Hành Phù Hợp:"
     echo "1.Windows 10 1809LTSC--ForWork"
     echo "2.Windows 8.1"
     read -p "Nhập Lựa Chọn Của Bạn: " HDH2
        if [ "$HDH2" -eq 1 ]; then
              if [ ! -e /workspaces/action/gdown!.py ]; then
                 echo "Downloading..."
                      if ! wget -O "/workspaces/action/gdown!.py" "https://github.com/nguyenbinh1289/y/raw/main/c.py"; then
                          echo "Download Failed!"
                          exit 1
                      fi
              fi
                    # Cài gdown
                     if ! command -v gdown &> /dev/null; then
                         echo "Installing gdown..."
                         pip install gdown || { echo "Failed to install gdown!"; exit 1; }
                     fi

                    # Chạy Script
                      if ! python3 gdown!.py; then
                          echo "Failed to Installing ISo"
                          exit 1     
                      fi
                          
      elif [ "$HDH2" -eq 2 ]; then
             if [ ! -e /mnt/a.iso ]; then
                  echo "Downloading..."
                       if ! aria2c -d /mnt/ -o "a.iso" -x 16 -s 16 "https://dn720006.ca.archive.org/0/items/Windows-8-1-ISO-Archive/Win8.1_English_x64.iso"; then
                            echo "Download Failed!"
                            exit 1
                       fi
             fi 
        fi
                         # Cài Driver cho Win
                           if [ ! -e /mnt/driver.iso ]; then
                                echo "Waiting!"
                                sleep 1
                                if ! aria2c -d /mnt/ -o driver.iso -x 16 -s 16 "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.266-1/virtio-win-0.1.266.iso"; then
                                   echo "Downloading Driver Failed!"
                                   exit 1
                                fi
                           fi
             
                          # Kiểm tra file ISO có thực sự tải được không
                             if [ ! -s /mnt/a.iso ] || [ ! -s /mnt/driver.iso ]; then
                                  echo "Error: ISO file is empty or corrupted!"
                                  sudo rm -f "/mnt/a.iso" "/mnt/driver.iso"
                                  exit 1 
                             fi
        
     #Starting Qemu
        sleep 3
        clear
        echo "Đang khởi chạy máy ảo..."
        echo "Đã khởi động VM thành công!"

       sudo kvm \
  -enable-kvm \
  -daemonize \
  -cpu host,+topoext,hv_relaxed,hv_spinlocks=0x1fff,hv-passthrough,+pae,+nx,kvm=on,+svm \
  -smp sockets=1,cores=2,threads=2 \
  -m 11G \
  -M q35,usb=on \
  -device usb-tablet \
  -vga virtio \
  -device virtio-balloon-pci \
  -device virtio-serial-pci \
  -device virtio-rng-pci \
  -device intel-hda \
  -device hda-duplex \
  -netdev user,id=n0,hostfwd=tcp::3389-:3389 \
  -device virtio-net-pci,netdev=n0 \
  -boot c \
  -uuid e47ddb84-fb4d-46f9-b531-14bb15156336 \
  -drive if=pflash,format=raw,readonly=off,file=/usr/share/ovmf/OVMF.fd \
  -drive file=/mnt/disk.img,format=raw,if=none,id=vdisk \
  -device virtio-blk-pci,drive=vdisk,serial=vdisk001 \
  -drive file=/dev/"$DL",format=raw,if=none,id=rawdisk \
  -device virtio-blk-pci,drive=rawdisk,serial=phys001 \
  -drive file=/mnt/driver.iso,media=cdrom \
  -drive file=/mnt/a.iso,media=cdrom \
  -chardev spicevmc,id=vdagent,name=vdagent \
  -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
  -spice port=${SPICE_PORT},disable-ticketing
        if [ ! -e ./tailscaled.state ]; then
            if ! sudo tailscaled --state=tailscaled.state; then
            echo "Nope..."
            exit 1
            fi
        fi
  fi
