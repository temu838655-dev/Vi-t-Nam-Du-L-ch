# Trạng thái build thử

## Hai nhánh cần phân biệt

- **Godot 4.4.1 prototype:** workflow `.github/workflows/android-apk.yml` xuất APK Android từ dự án Godot ở thư mục gốc. Đây là bản prototype cũ để kiểm tra luồng điều khiển cảm ứng và màn hình khởi đầu; không phải bản Unreal Engine 5.
- **Unreal Engine 5.8:** dự án chính nằm ở `Unreal/VietNamHanhTrinh.uproject`. Repository hiện có mã nguồn C++ và cấu hình nền tảng, nhưng chưa có Unreal Engine 5.8 toolchain/Editor trong GitHub Actions nên chưa thể tuyên bố đã biên dịch hoặc tạo APK UE5.

## Build thử hiện tại

Mỗi lần push lên `main`, workflow Godot sẽ:
1. Cài Godot 4.4.1 và Android SDK.
2. Import dự án Godot.
3. Xuất APK Android arm64.
4. Đăng APK thành GitHub Actions artifact.

Artifact chỉ được dùng để thử prototype Godot. Không dùng artifact này làm bản phát hành UE5.

## Điều kiện để build UE5 thật

Cần máy cài Unreal Engine 5.8, Android SDK/NDK tương thích và cấu hình Android SDK trong Unreal. Với iOS cần macOS, Xcode và provisioning/signing. Sau khi mở project, phải generate project files, compile module C++, tạo map trong Editor, đặt actor cần thiết và kiểm tra trên thiết bị trước khi phát hành.

## Những gì bản prototype Godot hiện có

Màn hình bắt đầu, điều khiển joystick cảm ứng, camera xoay bằng vuốt, nhân vật capsule, mặt đất thử nghiệm và HUD cơ bản. Bản này chưa đại diện cho đồ họa, địa hình hay hệ thống gameplay UE5 đang phát triển.
