import gdown

# URL file Google Drive
url = "https://drive.google.com/uc?id=1zI4C8oRRP7YlWZEWYySgUn0aVUWQhafJ"

# Đường dẫn lưu file sau khi tải
output = "/mnt/win2k12r2.zip"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
