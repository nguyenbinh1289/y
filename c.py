import gdown

# URL file Google Drive
url = "https://drive.google.com/u/1/uc?id=1i2e1XNJ3fjcFfHsAMyML5XCQ0HVxFkK_"

# Đường dẫn lưu file sau khi tải
output = "/mnt/Windows10 SuperLite.zip"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
