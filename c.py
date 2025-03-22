import gdown

# URL file Google Drive
url = "https://drive.google.com/uc?id=1t7UXFe86NzjGTpwWIcQsQz_2Nrdp52Ly"

# Đường dẫn lưu file sau khi tải
output = "win2019ltsc.zip"  # Đổi tên file tùy ý

# Tải file
gdown.download(url, output, quiet=False)

print(f"File đã được tải về và lưu tại: {output}")
