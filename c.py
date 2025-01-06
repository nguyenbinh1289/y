import gdown

# URL file Google Drive
url = "https://drive.google.com/uc?id=15bxO6NwNJwgOfgkv1c3hweloPAZg_kq9"

# Đường dẫn lưu file sau khi tải
output = "/mnt/win10lite.rar"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
