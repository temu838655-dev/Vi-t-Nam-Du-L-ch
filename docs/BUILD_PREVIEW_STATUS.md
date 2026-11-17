# Trạng thái build – Unreal Engine 5.8

## Engine và project
Dự án chỉ sử dụng Unreal Engine 5.8. Project chính: Unreal/VietNamHanhTrinh.uproject. Các tệp project, scene, script và workflow của engine cũ đã được gỡ khỏi nhánh main; không còn quy trình build APK từ engine cũ.

## Trạng thái hiện tại
- Có project descriptor, cấu hình Android/iOS và mã nguồn C++ cho các hệ thống gameplay nền tảng.
- Chưa xác nhận biên dịch module bằng Unreal Editor 5.8.
- Chưa có map hoàn chỉnh được tạo và kiểm thử trong Editor.
- Chưa có APK Android hoặc IPA iOS được build từ UE5 và kiểm thử trên thiết bị.
- Chưa hoàn thiện asset 3D, animation, giao diện UMG, đăng nhập Google/Apple và cloud save.

## Điều kiện để tạo bản thử UE5
1. Máy build phải cài đúng Unreal Engine 5.8 và toolchain C++ tương ứng.
2. Cấu hình Android SDK/NDK/JDK theo yêu cầu của phiên bản Unreal, bật Android platform support.
3. Generate project files, compile module và sửa mọi lỗi compile thực tế.
4. Mở Editor, tạo map thử nghiệm, đặt PlayerStart, NavMesh và actor cần thiết.
5. Chạy PIE/Standalone để kiểm tra trước khi package Android ARM64.
6. iOS cần macOS, Xcode, chứng chỉ và provisioning profile.

## Nguyên tắc phát hành
Chỉ gọi là bản build UE5 khi artifact được tạo từ project Unreal/VietNamHanhTrinh.uproject, có log build thành công và đã kiểm tra cài/chạy trên thiết bị. Không dùng APK từ engine khác để đại diện cho game UE5.