# Hướng Dẫn Cài Đặt - Face Recognition Attendance System

## 📋 Mục Lục
- [Yêu Cầu Hệ Thống](#-yêu-cầu-hệ-thống)
- [Cài Đặt Trên macOS](#-cài-đặt-trên-macos)
- [Cài Đặt Trên Linux](#-cài-đặt-trên-linux)
- [Cài Đặt Trên Windows](#-cài-đặt-trên-windows)
- [Chạy Ứng Dụng](#-chạy-ứng-dụng)
- [Xử Lý Lỗi Thường Gặp](#-xử-lý-lỗi-thường-gặp)
- [FAQ](#-faq)

---

## 💻 Yêu Cầu Hệ Thống

| Yêu cầu | Chi tiết |
|---------|----------|
| **RAM** | Tối thiểu 4GB (khuyến nghị 8GB) |
| **Ổ cứng** | 2GB trống |
| **Camera** | Webcam hoạt động |
| **Internet** | Cần kết nối để tải packages lần đầu |
| **Hệ điều hành** | Windows 10/11, macOS 10.15+, Ubuntu 20.04+ |

---

## 🍎 Cài Đặt Trên macOS

### Bước 1: Mở Terminal
- Nhấn `Command + Space`, gõ `Terminal`, nhấn Enter

### Bước 2: Di chuyển đến thư mục dự án
```bash
cd /đường/dẫn/đến/NhanDienKhuonMat
```
**Ví dụ:**
```bash
cd ~/Downloads/NhanDienKhuonMat
```

### Bước 3: Chạy script cài đặt
```bash
bash setup.sh
```

### Bước 4: Chờ cài đặt hoàn tất (5-15 phút)

### Bước 5: Chạy ứng dụng
```bash
bash start.sh
```

---

## 🐧 Cài Đặt Trên Linux

### Ubuntu / Debian / Linux Mint

#### Bước 1: Mở Terminal
- Nhấn `Ctrl + Alt + T`

#### Bước 2: Di chuyển đến thư mục dự án
```bash
cd /đường/dẫn/đến/NhanDienKhuonMat
```

#### Bước 3: Cấp quyền thực thi (nếu cần)
```bash
chmod +x setup.sh
```

#### Bước 4: Chạy script cài đặt
```bash
bash setup.sh
```

#### Bước 5: Chạy ứng dụng
```bash
bash start.sh
```

### Fedora / CentOS / RHEL
Tương tự như Ubuntu, script sẽ tự động nhận diện và cài đặt packages phù hợp.

### Arch Linux / Manjaro
Tương tự, script hỗ trợ pacman package manager.

---

## 🪟 Cài Đặt Trên Windows

### Cách 1: Sử dụng giao diện (Khuyến nghị)

#### Bước 1: Cài đặt
- Double-click vào file **`setup.bat`**
- Chờ cài đặt hoàn tất (10-20 phút)
- **Lưu ý:** Nếu Miniconda mới được cài, hãy đóng và mở lại Command Prompt/PowerShell

#### Bước 2: Chạy ứng dụng
- Double-click vào file **`start.bat`**

### Cách 2: Sử dụng Command Prompt

#### Bước 1: Mở Command Prompt
- Nhấn `Windows + R`, gõ `cmd`, nhấn Enter
- **Hoặc** chuột phải vào nút Start → Windows Terminal

#### Bước 2: Di chuyển đến thư mục dự án
```batch
cd C:\đường\dẫn\đến\NhanDienKhuonMat
```
**Ví dụ:**
```batch
cd C:\Users\TenBan\Downloads\NhanDienKhuonMat
```

#### Bước 3: Chạy script cài đặt
```batch
setup.bat
```

#### Bước 4: Chờ cài đặt hoàn tất (10-20 phút)

#### Bước 5: Chạy ứng dụng
```batch
start.bat
```

### Cách 3: Cài đặt thủ công (Khi setup.bat gặp lỗi)

Nếu `setup.bat` không hoàn thành hoặc gặp lỗi, bạn có thể cài đặt thủ công:

#### Bước 1: Mở Command Prompt hoặc PowerShell

#### Bước 2: Tạo môi trường conda
```batch
conda create -n face_attendance python=3.10 -y
```

#### Bước 3: Kích hoạt môi trường
```batch
conda activate face_attendance
```

#### Bước 4: Cài đặt các packages
```batch
pip install numpy==1.26.4 pandas==2.1.4 openpyxl==3.1.2
pip install opencv-python-headless PySide6 mediapipe
```

#### Bước 5: Cài đặt dlib (chọn 1 trong 2 cách)

**Cách A - Dùng pip:**
```batch
pip install dlib==19.24.2
```

**Cách B - Nếu pip fail, dùng conda-forge:**
```batch
conda install -c conda-forge dlib -y
```

#### Bước 6: Cài đặt face_recognition
```batch
pip install face_recognition==1.3.0
```

#### Bước 7: Chạy ứng dụng
```batch
python app_main.py
```

### Tóm tắt các file Windows

| File | Chức năng |
|------|-----------|
| **setup.bat** | Cài đặt Conda, tạo môi trường, cài dependencies (chạy 1 lần đầu) |
| **start.bat** | Khởi động ứng dụng (chạy mỗi lần sử dụng) |

---

## 🚀 Chạy Ứng Dụng

### Sau khi cài đặt thành công:

| Hệ điều hành | Lệnh chạy |
|--------------|-----------|
| **macOS** | `bash start.sh` |
| **Linux** | `bash start.sh` |
| **Windows** | Double-click `start.bat` |

### Cách khác (thủ công):
```bash
# Kích hoạt môi trường
conda activate face_attendance

# Chạy ứng dụng
python app_main.py
```

---

## ❌ Xử Lý Lỗi Thường Gặp

### 1. Lỗi "EnvironmentNameNotFound: Could not find conda environment"

**Thông báo lỗi:**
```
EnvironmentNameNotFound: Could not find conda environment: face_attendance
```

**Nguyên nhân:** Môi trường `face_attendance` chưa được tạo hoặc setup.bat không hoàn thành.

**Giải pháp 1 - Chạy lại setup.bat:**
```batch
.\setup.bat
```
Chờ đến khi hiện "Setup Complete!" rồi mới chạy `start.bat`.

**Giải pháp 2 - Tạo môi trường thủ công:**
```batch
conda create -n face_attendance python=3.10 -y
conda activate face_attendance
pip install numpy==1.26.4 pandas==2.1.4 openpyxl==3.1.2
pip install opencv-python-headless PySide6 mediapipe
conda install -c conda-forge dlib -y
pip install face_recognition==1.3.0
```

**Giải pháp 3 - Kiểm tra môi trường đã có chưa:**
```batch
conda env list
```
Nếu thấy `face_attendance` trong danh sách, thử chạy:
```batch
conda activate face_attendance
python app_main.py
```

---

### 2. Lỗi "conda: command not found"

**Nguyên nhân:** Conda chưa được thêm vào PATH

**Giải pháp macOS/Linux:**
```bash
# Thêm Miniforge vào PATH
export PATH="$HOME/miniforge3/bin:$PATH"
source "$HOME/miniforge3/etc/profile.d/conda.sh"

# Hoặc khởi động lại Terminal
```

**Giải pháp Windows:**
```batch
# Mở Anaconda Prompt thay vì Command Prompt thông thường
# Hoặc chạy lại setup.bat
```

---

### 3. Lỗi "Terms of Service" (ToS)

**Thông báo lỗi:**
```
CondaToSNonInteractiveError: Terms of Service have not been accepted
```

**Giải pháp:**
```bash
# Chấp nhận ToS cho các channels
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Sau đó chạy lại setup
bash setup.sh
```

---

### 4. Lỗi Build dlib thất bại

**Thông báo lỗi:**
```
ERROR: Failed building wheel for dlib
CMake Error...
```

**Giải pháp:**
```bash
# Xóa môi trường cũ
conda env remove -n face_attendance -y

# Cài dlib từ conda-forge (đã được xử lý trong setup.sh mới)
conda create -n face_attendance -c conda-forge --override-channels python=3.10 dlib -y
conda activate face_attendance
pip install numpy pandas opencv-python-headless PySide6 mediapipe face_recognition openpyxl
```

---

### 5. Lỗi "No module named 'cv2'" hoặc thiếu module

**Giải pháp:**
```bash
# Kích hoạt môi trường
conda activate face_attendance

# Cài lại package bị thiếu
pip install opencv-python-headless
# hoặc
pip install PySide6
pip install mediapipe
pip install face_recognition
```

---

### 6. Lỗi Camera không hoạt động

**Thông báo lỗi:**
```
Camera không nhận / Video không hiển thị
```

**Giải pháp macOS:**
1. Vào **System Preferences** → **Security & Privacy** → **Privacy** → **Camera**
2. Cho phép Terminal/ứng dụng truy cập Camera

**Giải pháp Linux:**
```bash
# Kiểm tra camera
ls /dev/video*

# Nếu không có, cài driver
sudo apt-get install v4l-utils

# Cấp quyền
sudo chmod 666 /dev/video0
```

**Giải pháp Windows:**
1. Vào **Settings** → **Privacy** → **Camera**
2. Bật "Allow apps to access your camera"

---

### 7. Lỗi GUI không hiển thị (Linux)

**Thông báo lỗi:**
```
qt.qpa.xcb: could not connect to display
```

**Giải pháp:**
```bash
# Cài đặt thư viện X11
sudo apt-get install libxcb-xinerama0 libxcb-cursor0 libxkbcommon-x11-0

# Thiết lập DISPLAY
export DISPLAY=:0

# Chạy lại
bash start.sh
```

---

### 8. Lỗi "Permission denied" (macOS/Linux)

**Giải pháp:**
```bash
# Cấp quyền thực thi
chmod +x setup.sh
chmod +x start.sh

# Chạy lại
bash setup.sh
```

---

### 9. Lỗi "Environment already exists"

**Giải pháp:**
```bash
# Xóa môi trường cũ
conda env remove -n face_attendance -y

# Chạy lại setup
bash setup.sh
```

---

### 10. Lỗi Download chậm / timeout

**Giải pháp:**
```bash
# Thử dùng mirror khác
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/

# Hoặc tăng timeout
conda config --set remote_read_timeout_secs 600

# Chạy lại setup
bash setup.sh
```

---

### 11. Lỗi Windows Defender chặn ứng dụng

**Giải pháp:**
1. Khi thấy cảnh báo "Windows protected your PC"
2. Click **More info**
3. Click **Run anyway**

---

### 12. Lỗi PySide6 / Qt không tương thích

**Thông báo lỗi:**
```
ImportError: DLL load failed / Qt platform plugin could not be initialized
```

**Giải pháp Windows:**
```batch
# Cài lại PySide6
pip uninstall PySide6 PySide6-Essentials PySide6-Addons shiboken6 -y
pip install PySide6==6.6.1
```

**Giải pháp Linux:**
```bash
# Cài thư viện Qt dependencies
sudo apt-get install libxcb-cursor0 libxcb-icccm4 libxcb-keysyms1 libegl1
```

---

### 13. Lỗi "Solving environment: failed"

**Giải pháp:**
```bash
# Xóa cache conda
conda clean --all -y

# Cập nhật conda
conda update conda -y

# Chạy lại setup
bash setup.sh
```

---

## ❓ FAQ

### Q: Mất bao lâu để cài đặt?
**A:** Khoảng 5-20 phút tùy tốc độ mạng và cấu hình máy.

### Q: Cần Internet không?
**A:** Cần Internet lần đầu để tải packages (~500MB). Sau đó có thể chạy offline.

### Q: Có thể cài trên máy không có GPU không?
**A:** Có, ứng dụng chạy được trên CPU. GPU chỉ giúp tăng tốc độ xử lý.

### Q: Làm sao để cập nhật ứng dụng?
**A:** Tải source code mới, chạy lại `setup.sh` hoặc `setup.bat`.

### Q: Dữ liệu khuôn mặt lưu ở đâu?
**A:** Trong thư mục `known_faces/` cùng cấp với source code.

### Q: Làm sao để backup dữ liệu?
**A:** Copy 2 thư mục:
- `known_faces/` - chứa ảnh khuôn mặt
- `attendance_records/` - chứa file điểm danh

### Q: Có thể chạy trên Raspberry Pi không?
**A:** Có thể, nhưng cần cài thêm dependencies. Khuyến nghị dùng Raspberry Pi 4 với 4GB RAM.

### Q: Gặp lỗi không có trong danh sách?
**A:** 
1. Chụp ảnh màn hình lỗi
2. Gửi nội dung lỗi để được hỗ trợ
3. Thử xóa môi trường và cài lại từ đầu:
```bash
conda env remove -n face_attendance -y
bash setup.sh
```

---

## 📞 Liên Hệ Hỗ Trợ

Nếu gặp vấn đề không thể giải quyết:
1. Tạo issue trên GitHub repository
2. Đính kèm:
   - Hệ điều hành đang dùng
   - Thông báo lỗi đầy đủ
   - Các bước đã thử

---

## 📝 Ghi Chú Phiên Bản

| Phiên bản | Ngày | Thay đổi |
|-----------|------|----------|
| 1.0 | 2024 | Phiên bản đầu tiên |
| 1.1 | 2024 | Thêm hỗ trợ Miniforge, fix lỗi ToS |
| 1.2 | 2025 | Fix lỗi build dlib với CMake mới |

---

**Chúc bạn cài đặt thành công! 🎉**
