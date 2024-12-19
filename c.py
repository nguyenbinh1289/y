import gdown

# URL file Google Drive
url = "https://drive.google.com/uc?id=1j6tn7iacA-cqjRvbMVodz0WQyMdsfqg9"

# Đường dẫn lưu file sau khi tải
output = "/mnt/winXP.zip"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
