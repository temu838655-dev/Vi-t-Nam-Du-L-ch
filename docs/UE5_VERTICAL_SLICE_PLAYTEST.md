# Vertical slice – hướng dẫn chạy thử UE5.8

## Mục tiêu bản thử
Đây là lát cắt gameplay kỹ thuật đầu tiên, không phải bản phát hành hoàn chỉnh. Mục tiêu là xác minh project có thể mở trong Unreal Editor 5.8, khởi tạo khu vực blockout Hồ Hoàn Kiếm, spawn nhân vật, nhận điều khiển và lưu tiến trình.

## Thành phần hiện có trong mã nguồn
- GameMode đặt PlayerController và PlayerCharacter mặc định.
- Nếu level chưa có khu vực mẫu, GameMode tự tạo greybox Hồ Hoàn Kiếm.
- Nếu chưa có nhà gia đình, GameMode dựng một starter-home greybox; PlayerStart mặc định đặt bên ngoài căn nhà để nhân vật bắt đầu cuộc sống tại nhà, không phải giữa Hồ Gươm.
- PlayerCharacter có camera góc nhìn thứ ba, di chuyển, chạy, nhảy và trace tương tác.
- PlayerController hỗ trợ gắn Widget Blueprint HUD cảm ứng.
- SaveGame lưu vị trí, tiền, hồ sơ nhân vật/gia đình và lịch game.
- Đồng hồ prototype tự tăng khi có save: cứ 5 giây thực tế tăng 5 phút trong game. Có thể chỉnh hai thông số trong class defaults của GameMode. Không có save thì đồng hồ không tự tạo save và không tự chạy.

## Các bước chạy thử trong Unreal Editor
1. Cài Unreal Engine 5.8 cùng C++ toolchain và Android support.
2. Mở project tại Unreal/VietNamHanhTrinh.uproject, generate project files và compile module.
3. Tạo một level mới, đặt GameMode mặc định là AVNHGameMode (hoặc Blueprint subclass).
4. Lưu level làm map thử nghiệm; chọn map này làm Editor Startup Map và Game Default Map trong Project Settings.
5. Trong World Settings, xác nhận GameMode override đúng. Nếu chưa tạo PlayerStart hoặc khu vực mẫu, GameMode bootstrap sẽ thử tạo chúng khi khởi tạo map.
6. Nhấn Play trong Editor. Kiểm tra nhân vật spawn, camera, di chuyển bàn phím và va chạm greybox.
7. Tạo save thử bằng cách gọi CreateNewLife từ Blueprint/UI thử nghiệm. Sau khi có save, kiểm tra đồng hồ tăng 5 phút sau mỗi 5 giây thực tế; dừng PIE rồi chạy lại để xác minh dữ liệu đã lưu.
8. Gắn Widget Blueprint kế thừa UVNHMobileHUDWidget vào Blueprint subclass của PlayerController để thử joystick/các nút cảm ứng.
9. Sau khi PIE ổn định, package Android ARM64 và kiểm tra cài đặt, điều khiển cảm ứng, nhiệt độ, FPS, lưu/tải trên thiết bị thật.

## Điều kiện chưa được hoàn thành
- Repository chưa chứa map .umap được tạo và lưu bởi Unreal Editor.
- Chưa có Widget Blueprint hoàn chỉnh, menu New Game/Continue, UI chọn nhân vật/nghề nghiệp.
- Chưa có nhà gia đình có thể đi vào, mô hình bố mẹ, hội thoại hoặc lịch AI tự vận hành.
- Greybox Hồ Gươm chưa phải bản tái tạo đo đạc chính xác; chưa có bộ asset 3D/animation chất lượng sản xuất.
- Chưa có log compile UE5.8, APK/IPA hoặc kết quả kiểm thử thiết bị trong repository.

## Tiêu chí chấp nhận bản thử đầu tiên
- [ ] Project mở và compile sạch bằng đúng UE5.8.
- [ ] Level khởi động được, không rơi khỏi map hoặc spawn dưới mặt đất.
- [ ] Nhân vật di chuyển, xoay camera, nhảy và va chạm ổn định.
- [ ] Save mới được tạo có chủ đích; Continue tải đúng save.
- [ ] Đồng hồ chỉ chạy khi đã có save và không reset khi khởi động lại.
- [ ] HUD cảm ứng thao tác được trên Android.
- [ ] APK cài và chạy được trên ít nhất một thiết bị Android thật.

Không đánh dấu tiêu chí nào là đạt nếu chưa kiểm tra trực tiếp. Chưa thể tạo APK/IPA UE5 từ môi trường chỉnh sửa repository nếu không có Unreal Engine 5.8 và toolchain tương ứng.
