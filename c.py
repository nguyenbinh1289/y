import gdown

# URL file Google Drive
url = "https://drive.google.com/uc?id=1z7pmIXtKvDMMlIa66nQqwrYoAy7iJUCW"

# Đường dẫn lưu file sau khi tải
output = "/mnt/win2012r2.zip"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
