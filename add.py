import gdown

# URL file Google Drive (thay đổi từ dạng "view" sang "uc" để gdown hoạt động)
url = "https://drive.google.com/uc?id=1-3J0YK2dAL0pDD-95FvqRZX--RgUkFBd"

# Đường dẫn lưu file sau khi tải
output = "/mnt/linux-lite5.2-64bit.zip"  # Đường dẫn đầy đủ nơi lưu file

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
