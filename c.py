import gdown
import os

iso_path = "/mnt/winwork.iso"
url = "https://drive.google.com/uc?id=1a_HF_HCmw95Sj8u0T9_mvsHevQ3umh4t"  # Thay thế bằng link tải file ISO

# Kiểm tra nếu file ISO không tồn tại
if not os.path.exists(iso_path):
    print("Downloading...")

    # Sử dụng gdown để tải file
    result = gdown.download(url, iso_path, quiet=False)

    # Kiểm tra xem tải xuống có thành công không
    if result is None:  # Nếu gdown thất bại, result sẽ là None
        print("Download ISO Failed!")
        exit(1)

# Kiểm tra nếu file ISO trống hoặc bị lỗi
if os.path.exists(iso_path) and os.path.getsize(iso_path) == 0:
    print("Error: ISO file is empty or corrupted!")
    exit(1)

print("Download successful!")
print(f"File đã được tải về và lưu tại: {iso_path}")
