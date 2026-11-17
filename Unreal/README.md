# Unreal Engine 5.8 – Việt Nam Hành Trình Bất Tận

Đây là project game duy nhất của repository. Engine mục tiêu là Unreal Engine 5.8; không duy trì project game song song bằng engine khác.

## Nền tảng hiện có
- Unreal project descriptor và C++ runtime module.
- Cấu hình renderer ưu tiên thiết bị di động.
- Cấu hình Android ARM64 và iOS.
- GameMode, PlayerController hỗ trợ cảm ứng, nhân vật góc nhìn thứ ba và SaveGame.
- Các hệ thống prototype cho POI, khu vực Hà Nội, phương tiện, NPC, giao thông và nhiên liệu.

## Mở project
1. Cài Unreal Engine 5.8 cùng toolchain C++.
2. Cài thành phần Android SDK/NDK phù hợp nếu build Android.
3. Mở VietNamHanhTrinh.uproject trong Unreal Editor.
4. Generate project files và biên dịch module C++.
5. Tạo map đầu tiên, đặt PlayerStart và actor blockout cần thiết.
6. Kiểm tra trong Editor trước khi package Android.

## Giới hạn hiện tại
Đây là nền tảng mã nguồn, chưa phải game hoàn chỉnh. Chưa xác nhận compile, chưa có map hoàn chỉnh, asset 3D sản xuất, animation, UMG hoàn chỉnh hoặc APK/IPA đã kiểm thử. iOS packaging/signing cần macOS và Xcode.