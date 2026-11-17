# Trạng thái build – Unreal Engine 5.8

## Engine và project
Dự án chỉ sử dụng Unreal Engine 5.8. Project chính: Unreal/VietNamHanhTrinh.uproject. Các tệp project, scene, script và workflow của engine cũ đã được gỡ khỏi nhánh main; không còn quy trình build APK từ engine cũ.

## Những phần mã nguồn vừa hoàn thiện thêm
- GameMode tự spawn blockout Hồ Hoàn Kiếm và PlayerStart dự phòng nếu level chưa có các actor này; mặt đất và footprint hồ đã được chỉnh khớp hơn với kích thước greybox.
- Có cầu nối C++ UVNHMobileHUDWidget cho joystick, vuốt camera, chạy, nhảy, tương tác và điều khiển xe; PlayerController có thể spawn Widget Blueprint cấu hình trong class defaults và chuyển sang GameAndUI.
- Xe theo dõi từng nguồn dừng đèn giao thông riêng; một đèn chuyển xanh hoặc bị hủy không xóa lệnh dừng do đèn khác phát ra.

## Trạng thái hiện tại
- Có project descriptor, cấu hình Android/iOS và mã nguồn C++ cho các hệ thống gameplay nền tảng.
- Đã cập nhật mã nguồn và tài liệu; **chưa xác nhận biên dịch module bằng Unreal Editor 5.8**.
- Repository chưa có map .umap hoàn chỉnh được tạo và kiểm thử trong Editor. GameMode bootstrap chỉ dựng blockout khi chạy trong một level hợp lệ.
- Widget Blueprint, đồ họa nút, joystick trực quan, NavMesh và cấu hình Blueprint vẫn cần tạo trong Unreal Editor.
- Chưa có APK Android hoặc IPA iOS được build từ UE5 và kiểm thử trên thiết bị.
- Chưa hoàn thiện asset 3D, animation, đăng nhập Google/Apple và cloud save.

## Điều kiện để tạo bản thử UE5
1. Máy build phải cài đúng Unreal Engine 5.8 và toolchain C++ tương ứng.
2. Cấu hình Android SDK/NDK/JDK theo yêu cầu của phiên bản Unreal, bật Android platform support.
3. Generate project files, compile module và sửa mọi lỗi compile thực tế.
4. Tạo/lưu level trong Unreal Editor; GameMode có thể tự thêm blockout và PlayerStart nếu thiếu.
5. Tạo WBP_MobileHUD từ parent VNHMobileHUDWidget và gán vào Blueprint subclass của VNHPlayerController.
6. Chạy PIE/Standalone, kiểm tra input, AI, collision và hiệu năng trước khi package Android ARM64.
7. iOS cần macOS, Xcode, chứng chỉ và provisioning profile.

## Nguyên tắc phát hành
Chỉ gọi là bản build UE5 khi artifact được tạo từ project Unreal/VietNamHanhTrinh.uproject, có log build thành công và đã kiểm tra cài/chạy trên thiết bị. Không dùng APK từ engine khác để đại diện cho game UE5.