import gdown

# URL file Google Drive
url = "https://drive.google.com/u/1/uc?id=1Ipu4zbxH52T3km44E8pkR-nZWc_YScKH"

# Đường dẫn lưu file sau khi tải
output = "/mnt/"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
