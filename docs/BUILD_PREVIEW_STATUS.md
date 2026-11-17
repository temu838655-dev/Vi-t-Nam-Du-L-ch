# Trạng thái build – Unreal Engine 5.8

## Engine và project
Dự án chỉ sử dụng Unreal Engine 5.8. Project chính: Unreal/VietNamHanhTrinh.uproject. Các tệp project, scene, script và workflow của engine cũ đã được gỡ khỏi nhánh main; không còn quy trình build APK từ engine cũ.

## Những phần mã nguồn và hệ thống đã có
- GameMode tự spawn blockout Hồ Hoàn Kiếm và PlayerStart dự phòng nếu level chưa có các actor này.
- Có cầu nối C++ cho joystick, vuốt camera, chạy, nhảy, tương tác và điều khiển xe; PlayerController có thể spawn widget cấu hình trong class defaults.
- Có prototype xe, xe máy, NPC tuần tra, tuyến giao thông, đèn tín hiệu, trạm xăng, save game, lịch gia đình và đồng hồ game.
- Có nhà gia đình dạng greybox và điểm xuất phát trước nhà; chưa có nội thất, cửa tương tác hoặc bố mẹ NPC hoàn chỉnh.
- Có tài liệu thiết kế đời sống, gia đình, nghề nghiệp, lịch sinh hoạt và tiêu chuẩn độ chân thực Việt Nam.

## Trạng thái kỹ thuật
- Có project descriptor, cấu hình Android/iOS và mã nguồn C++ cho các hệ thống gameplay nền tảng.
- **Chưa xác nhận biên dịch module bằng Unreal Editor 5.8.**
- Repository chưa có map .umap hoàn chỉnh được tạo và kiểm thử trong Editor.
- Widget Blueprint, đồ họa nút, joystick trực quan, NavMesh và cấu hình Blueprint vẫn cần tạo trong Unreal Editor.
- Chưa có APK Android hoặc IPA iOS được build từ UE5 và kiểm thử trên thiết bị.
- Chưa hoàn thiện asset 3D, animation, đăng nhập Google/Apple và cloud save.

## GitHub Actions – Android APK

Workflow: `.github/workflows/ue5-android-apk.yml`

Quy trình có hai job:
1. `github-preflight` chạy trên GitHub-hosted Ubuntu để kiểm tra cấu trúc project UE5.8 và cấu hình nền tảng.
2. `android-apk` chạy trên Windows self-hosted runner có UE5.8 + Android SDK/NDK/JDK để biên dịch và đóng gói APK.

Cần đăng ký runner Windows x64 và đặt repository variable `UE_ROOT`. Nếu chưa có runner phù hợp, job APK sẽ chờ runner; GitHub-hosted preflight không thể thay thế bước biên dịch Unreal.

Khi build thành công, workflow upload artifact `VietNamHanhTrinh-Android-ARM64-Development` hoặc bản Shipping trong 14 ngày. Chưa có log compile thành công và chưa có APK được xác minh cho commit hiện tại.

Hướng dẫn: [BUILD_ANDROID_APK_UE58.md](BUILD_ANDROID_APK_UE58.md).

## iOS
iOS cần macOS runner, Xcode, chứng chỉ ký và provisioning profile. Workflow Android hiện tại không tạo IPA.

## Nguyên tắc phát hành
Chỉ gọi là bản build UE5 khi artifact được tạo từ project Unreal/VietNamHanhTrinh.uproject, có log build thành công và đã kiểm tra cài/chạy trên thiết bị. Không dùng APK từ engine khác để đại diện cho game UE5.
