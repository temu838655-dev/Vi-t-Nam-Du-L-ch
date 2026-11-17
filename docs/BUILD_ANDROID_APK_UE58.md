# Build APK Android bằng Unreal Engine 5.8

## Quy trình GitHub Actions

Workflow `UE5 Android APK Playtest` tự chạy chặng preflight mỗi khi có commit mới lên nhánh `main`; chặng đóng gói APK chỉ chạy khi bạn chủ động chọn Run workflow. Workflow chạy theo hai chặng:

1. **GitHub-hosted preflight (Ubuntu):** kiểm tra file project, EngineAssociation 5.8, runtime module, cấu hình Android ARM64 và định danh package Android/iOS.
2. **UE5.8 packaging (Windows self-hosted):** biên dịch, cook và đóng gói APK bằng Unreal Automation Tool.

Chặng đầu chạy trên GitHub-hosted runner thông thường. Chặng thứ hai cần một Windows runner có Unreal Engine 5.8 và Android toolchain. Việc kiểm tra preflight thành công không đồng nghĩa project đã biên dịch được.

## Điều kiện bắt buộc cho runner đóng gói

1. Có máy Windows hoặc máy ảo Windows chạy được GitHub Actions self-hosted runner.
2. Cài Unreal Engine 5.8 và C++ toolchain tương ứng.
3. Trong Unreal Engine Android settings / Turnkey, cài và xác nhận Android SDK, NDK, JDK theo phiên bản UE5.8 yêu cầu. Kiểm tra Android platform trong Unreal trước khi build.
4. Đăng ký runner cho repository này tại Settings → Actions → Runners. Chọn Windows x64 và để runner online.
5. Trong Settings → Secrets and variables → Actions → Variables, tạo repository variable `UE_ROOT`, trỏ tới thư mục Unreal Engine 5.8, ví dụ `C:\Program Files\Epic Games\UE_5.8`.
6. Runner phải chạy dưới tài khoản Windows có quyền truy cập Unreal Engine, Android SDK/NDK và workspace.

## Chạy đóng gói

1. Mở tab Actions của repository.
2. Chọn workflow **UE5 Android APK Playtest**.
3. Nhấn Run workflow và chọn Development để thử nghiệm.
4. Theo dõi job `github-preflight`. Nếu thành công, GitHub chuyển sang job `android-apk`.
5. Khi job đóng gói hoàn tất thành công, tải artifact `VietNamHanhTrinh-Android-ARM64-Development` ở trang workflow run.
6. Giải nén và cài APK trên thiết bị Android ARM64.

## Workflow kiểm tra gì?

- Preflight kiểm tra JSON project descriptor, EngineAssociation 5.8, module, target Game, include order UE5.8 và các cài đặt Android/iOS thiết yếu.
- Windows runner kiểm tra `UE_ROOT`, `RunUAT.bat` và file project.
- Gọi Unreal Automation Tool `BuildCookRun` với Android / ASTC.
- Dừng nếu Unreal trả mã lỗi khác 0, không tìm thấy APK hoặc APK nhỏ bất thường.
- Đổi tên APK và upload dưới dạng GitHub Actions artifact trong 14 ngày.

## Giới hạn cần nói rõ

- GitHub-hosted runner không được workflow này dùng để biên dịch UE5.8; workflow không tự tải Unreal Engine vì dung lượng lớn và điều kiện cấp phép/phân phối.
- Nếu chưa có Windows self-hosted runner UE5.8 online, job đóng gói sẽ ở trạng thái queued sau khi preflight thành công.
- Chưa có log compile hoặc APK được tạo thành công cho commit hiện tại. Không xem preflight hoặc việc thêm workflow là bằng chứng game đã build được.
- Workflow này chỉ tạo Android APK. iOS IPA cần macOS runner, Xcode, provisioning profile và signing riêng.
- Bản thử hiện tại vẫn là prototype; cần kiểm thử trên điện thoại trước khi phát hành.
