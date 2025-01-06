import gdown

# URL file Google Drive
url = "https://drive.google.com/uc?id=1zRgd8Piv5r7aVmrg8aBLlnGdebE8eqUG"

# Đường dẫn lưu file sau khi tải
output = "/mnt/win10lite.rar"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
