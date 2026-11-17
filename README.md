# Việt Nam – Hành Trình Bất Tận

Game mô phỏng cuộc sống và du lịch Việt Nam trên Android. Đây là **prototype kỹ thuật 0.1.0**, chưa phải game hoàn chỉnh và chưa chứa dữ liệu địa phương hoặc asset ảnh thực tế.

## Công nghệ
- Godot 4.4.1, GDScript, renderer Compatibility ưu tiên tương thích Android.
- Điều khiển nhân vật, joystick cảm ứng, camera xoay.
- Kiến trúc tương tác địa điểm và cấu hình đồ họa thích ứng.
- GitHub Actions build APK Android arm64.

## Chạy thử
1. Cài Godot 4.4.1 Standard.
2. Mở project.godot.
3. Chạy scene chính.
4. Máy tính: WASD di chuyển; giữ chuột phải và kéo để xoay camera.
5. Android: joystick trái di chuyển; kéo vùng phải màn hình để xoay camera.

## Build APK
1. Mở tab Actions và chạy workflow Android APK Release.
2. Tải APK tại Artifacts của lần chạy.
3. Để phát hành GitHub Release, tạo tag v0.1.0 và push tag đó. Workflow sẽ đính kèm APK.

## Chữ ký và mã kích hoạt
Game không có mã kích hoạt hoặc khóa bản quyền. APK vẫn cần chữ ký kỹ thuật Android. Prototype dùng cấu hình export debug; phát hành Google Play hoặc cập nhật lâu dài cần khóa ký release riêng trong GitHub Secrets.

## Lộ trình
- Mốc 1: điều khiển nhân vật, camera, joystick và pipeline APK.
- Mốc 2: streaming bản đồ, dữ liệu đường và địa danh có giấy phép.
- Mốc 3: địa phương mẫu với ảnh tham chiếu và môi trường chân thực.
- Mốc 4: NPC, công việc, tiền tệ, cửa hàng, phương tiện, nhiên liệu.
- Mốc 5: du lịch, ẩm thực, bãi biển, nhiệm vụ và tối ưu theo thiết bị.

## Tính chân thực
Các hình đơn giản trong prototype chỉ để kiểm tra điều khiển và pipeline. Bản đồ/địa danh thực tế cần nguồn dữ liệu và quyền sử dụng phù hợp; không thể tuyên bố tái tạo 100% mọi địa điểm ngay trong bản đầu tiên.
