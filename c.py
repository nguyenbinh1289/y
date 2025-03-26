import gdown

# URL file Google Drive
url = "https://drive.google.com/uc?id=1wpE_EE4JDUtD77ILXcz5xl-bOUppinSP"

# Đường dẫn lưu file sau khi tải
output = "/mnt/winwork.iso"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
