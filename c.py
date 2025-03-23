import gdown

# URL file Google Drive
url = "https://drive.google.com/uc?id=13TX80UNJQUcVwg1ullq2tfSmqji_vBHe"

# Đường dẫn lưu file sau khi tải
output = "winwork.iso"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
