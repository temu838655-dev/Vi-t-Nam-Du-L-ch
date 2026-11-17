# Điều khiển nhân vật mobile – UE5

## Mã nguồn
- AVNHPlayerCharacter kế thừa ACharacter, sử dụng capsule collision và CharacterMovement.
- Camera góc nhìn thứ ba dùng SpringArm và CameraComponent, có camera lag và kiểm tra va chạm.
- Các hàm BlueprintCallable hỗ trợ joystick, vuốt camera, chạy nhanh và nhảy.

## Kết nối Widget Blueprint
1. Tạo Widget Blueprint tên WBP_MobileHUD.
2. Thêm joystick bên trái và vùng vuốt camera bên phải.
3. Khi joystick thay đổi, gọi SetMoveInput(Forward, Right) trên Pawn đang điều khiển.
4. Khi thả joystick, gọi SetMoveInput(0, 0).
5. Khi kéo vùng camera, gọi AddLookInput(DeltaX, DeltaY).
6. Nút chạy gọi SetSprinting(true) khi nhấn và SetSprinting(false) khi thả.
7. Nút nhảy gọi TriggerJump() khi nhấn và StopJump() khi thả.

## Thông số mặc định khởi điểm
- Đi bộ: 360 cm/s; chạy nhanh: 560 cm/s.
- Lực nhảy: 420 cm/s; camera boom: 360 cm.
- Độ nhạy camera cảm ứng: 0.12.

Các thông số cần playtest trên điện thoại để cân chỉnh. Widget, skeletal mesh, animation blueprint và bản đồ 3D chưa được tạo trong commit này.

## Tương tác
- Nút HUD gọi `TryInteract()` để kiểm tra vật thể trước camera trong khoảng cách cấu hình.
- Actor tương tác triển khai `UVNHInteractable`; xem `docs/UE5_POI_INTERACTION.md` để tạo điểm tham quan Blueprint.
