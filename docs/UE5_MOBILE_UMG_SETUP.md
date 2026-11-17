# UMG điều khiển cảm ứng – Android và iOS

## Mục tiêu
C++ cung cấp lớp cầu nối UVNHMobileHUDWidget; phần hình ảnh được tạo bằng Widget Blueprint trong Unreal Editor. Cách này giữ giao diện có thể chỉnh sửa mà không hard-code vị trí nút trong C++.

## Thành phần mã nguồn
- VNHMobileHUDWidget.h/.cpp: API BlueprintCallable cho joystick, vuốt camera, chạy, nhảy, tương tác và điều khiển xe.
- VNHPlayerController: nhận MobileHUDClass, tạo widget cho local player và chuyển sang GameAndUI khi HUD đã được cấu hình.
- VietNamHanhTrinh.Build.cs: phụ thuộc module UMG.

## Tạo giao diện trong Unreal Editor
1. Mở project UE5.8 và compile module C++.
2. Trong Content Browser, tạo Widget Blueprint tên WBP_MobileHUD, chọn parent class VNHMobileHUDWidget.
3. Dùng Canvas Panel làm root; bố trí joystick ở góc trái dưới, vùng vuốt camera ở nửa phải, các nút chạy/nhảy/tương tác ở cạnh phải.
4. Với joystick, tạo điều khiển analog hoặc widget joystick riêng; khi giá trị thay đổi, chuẩn hóa trục X/Y về khoảng -1..1 rồi gọi SetMoveStick. Khi thả tay gọi ClearMoveStick.
5. Với vùng camera, tính delta vị trí ngón tay giữa hai lần cập nhật và gọi AddLookDrag. Không gửi tọa độ màn hình tuyệt đối.
6. Nút chạy: OnPressed gọi SetSprintHeld(true), OnReleased gọi SetSprintHeld(false).
7. Nút nhảy: OnPressed gọi SetJumpHeld(true), OnReleased gọi SetJumpHeld(false).
8. Nút tương tác: OnClicked gọi PressInteract.
9. Tạo nút ga/trái/phải/phanh cho xe và nối lần lượt tới SetVehicleThrottleInput, SetVehicleSteeringInput, SetVehicleBrakeInput; nút xuống xe gọi PressExitVehicle.
10. Tạo Blueprint subclass từ VNHPlayerController, đặt MobileHUDClass = WBP_MobileHUD.
11. Tạo Blueprint subclass từ VNHGameMode, đặt Player Controller Class thành Blueprint controller vừa tạo; chọn GameMode Blueprint làm default game mode trong Project Settings/Maps & Modes.
12. Test bằng New Editor Window/Standalone với giả lập touch, sau đó test trên thiết bị Android/iOS.

## Quy tắc điều khiển
- Joystick phải trả về 0 khi ngón tay nhấc khỏi màn hình hoặc widget mất focus.
- Vuốt camera nên dùng một ngón riêng, không lấy input từ vùng joystick hoặc nút UI.
- Khi xe đang được Possess, widget sẽ gửi ga/đánh lái tới AVNHVehiclePawn; khi xuống xe, các giá trị ga và lái được reset.
- Không để nút ga hoặc phanh bị giữ sau khi OnTouchEnded, OnReleased hoặc khi đổi Pawn.
- Bố cục cần kiểm tra ở tỷ lệ 16:9, 20:9, tablet, safe area tai thỏ và cả hướng ngang/dọc.

## Trạng thái và giới hạn
Cầu nối C++ và cơ chế spawn HUD đã được thêm vào repository. Widget Blueprint, đồ họa nút, logic joystick trực quan, safe-area layout và kiểm thử đa thiết bị vẫn cần thực hiện trong Unreal Editor. Chưa xác nhận compile hoặc build APK/IPA.