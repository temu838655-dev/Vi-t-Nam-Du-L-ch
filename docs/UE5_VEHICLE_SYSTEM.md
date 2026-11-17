# Hệ thống phương tiện điều khiển được – bản arcade nền tảng

## Đã thêm
- `AVNHDriveableVehicle` là Pawn có collision box, mesh hiển thị, camera góc nhìn thứ ba và API điều khiển.
- Người chơi tương tác với xe qua interface `VNHInteractable`; xe lưu nhân vật và PlayerController rồi chuyển quyền điều khiển sang Pawn xe.
- Khi thoát xe, quyền điều khiển trả lại nhân vật; nhân vật được hiện lại và bật collision.
- Có API BlueprintCallable để joystick/nút ga, lái, phanh và thoát xe gọi trực tiếp.
- Tốc độ có thể đọc bằng `GetSpeedKmh()`.

## Tạo xe trong Unreal Editor
1. Compile project.
2. Tạo Blueprint kế thừa `VNHDriveableVehicle`.
3. Gán mesh xe máy hoặc ô tô có giấy phép vào component `VehicleMesh`.
4. Điều chỉnh kích thước `CollisionBox` cho đúng loại xe.
5. Đặt xe vào level, bật collision phù hợp và thử tương tác bằng phím E.
6. Tạo HUD riêng cho xe: joystick lái, ga, phanh và nút xuống xe.
7. Trong widget, gọi `SetVehicleInput(Throttle, Steering)`, `SetBrakeInput(bool)` và `ExitVehicle()`.

## Phím thử nghiệm trên máy tính
- W/S: tiến/lùi.
- A/D: rẽ trái/phải.
- Space: phanh.
- F: xuống xe.

## Giới hạn kỹ thuật cần biết
Đây là bộ điều khiển arcade đơn giản dùng dịch chuyển Pawn có sweep collision. Nó chưa phải mô phỏng xe vật lý thực tế: chưa có bánh xe vật lý, hệ thống treo, mô-men xoắn, hộp số, ABS, va chạm thân xe hoặc mô phỏng xe máy cân bằng. Không gọi đây là Chaos Vehicles. Bản vật lý nâng cao cần tích hợp Chaos Vehicles hoặc hệ thống xe máy tùy chỉnh, cùng mesh/rig/bánh xe và kiểm thử trên thiết bị.
