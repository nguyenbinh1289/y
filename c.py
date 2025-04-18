import gdown
import os

print('1.\tNo SoftWare-10\n2.\tWin7')

Version = input("Chọn phiên Bản Phù Hợp: ")
iso_path = "/mnt/a.iso"
if Version == "1":
    url = "https://drive.google.com/uc?id=1wpE_EE4JDUtD77ILXcz5xl-bOUppinSP"
elif Version == "2":
    url = "https://drive.google.com/uc?id=1qilZKoRPTueRs5BxCbNTMi2uMIIF6Bhu"
else:
    print('Try Again!')
    exit(1)

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

print(f"File đã được tải về và lưu tại: {iso_path}")
