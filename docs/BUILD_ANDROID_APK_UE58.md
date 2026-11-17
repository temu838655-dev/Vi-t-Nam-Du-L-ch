# Build APK Android bằng Unreal Engine 5.8

## Trạng thái thực tế
Workflow này đóng gói đúng project Unreal Engine 5.8, không dùng Godot. Nó chỉ chạy trên Windows self-hosted runner đã cài UE5.8 và Android toolchain. GitHub-hosted runner thông thường không có Unreal Engine 5.8 hoặc Android SDK/NDK phù hợp để build dự án này.

## Chuẩn bị runner (làm một lần)
1. Dùng máy Windows có Unreal Engine 5.8 đã cài.
2. Trong Unreal Engine Android settings / Turnkey, cài và xác nhận Android SDK, NDK, JDK theo phiên bản UE5.8 yêu cầu. Kiểm tra Android platform trong Unreal trước khi build.
3. Cài Git và đăng ký GitHub Actions self-hosted runner cho repository này theo Settings → Actions → Runners. Chọn Windows x64; để runner online.
4. Trong repository Settings → Secrets and variables → Actions → Variables, tạo repository variable tên `UE_ROOT`, giá trị là thư mục cài Unreal Engine 5.8, ví dụ `C:\Program Files\Epic Games\UE_5.8`.
5. Runner phải chạy dưới tài khoản Windows có quyền truy cập Unreal Engine, Android SDK/NDK và workspace.

## Chạy đóng gói
1. Mở tab Actions của repository.
2. Chọn workflow **UE5 Android APK Playtest**.
3. Nhấn Run workflow, chọn Development cho bản thử.
4. Khi job hoàn tất thành công, tải artifact `VietNamHanhTrinh-Android-ARM64-Development` ở trang run.
5. Giải nén artifact và cài APK trên thiết bị Android ARM64. Bản này là prototype; chưa phải bản phát hành Google Play.

## Workflow làm gì
- Kiểm tra `UE_ROOT`, `RunUAT.bat` và file project.
- Gọi Unreal Automation Tool BuildCookRun với Android / ASTC / ARM64 theo cấu hình project.
- Dừng ngay nếu Unreal trả mã lỗi khác 0.
- Tìm APK, đổi tên, kiểm tra file lớn hơn 1 MB rồi upload thành GitHub Actions artifact trong 14 ngày.

## Giới hạn
- Workflow không thể tự tải Unreal Engine 5.8 do điều khoản phân phối và dung lượng engine; cần cài trên runner.
- Không có runner UE5.8 đang online thì job sẽ ở trạng thái queued, không thể sinh APK.
- Chưa có log compile hoặc APK được tạo thành công cho commit hiện tại. Không xem workflow được thêm vào là bằng chứng game đã build được.
- iOS IPA cần macOS runner, Xcode, provisioning profile và signing; workflow này chỉ tạo Android APK.
