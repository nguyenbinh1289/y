import gdown

# URL file Google Drive
url = "https://drive.google.com/uc?id=1FZSJJFKjn7uxP1AZmIzq4zt27MZ1HNpJ"

# Đường dẫn lưu file sau khi tải
output = "/mnt/winwork.iso"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
