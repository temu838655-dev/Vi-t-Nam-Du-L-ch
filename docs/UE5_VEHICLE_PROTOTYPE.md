# Hệ thống phương tiện – bản điều khiển thử nghiệm

## Mã nguồn
`AVNHVehiclePawn` là Pawn phương tiện điều khiển kiểu arcade để kiểm tra vòng lặp lên xe, lái xe và xuống xe. Nó chưa phải mô phỏng vật lý xe hoàn chỉnh.

### Tính năng
- Nhân vật tương tác với phương tiện qua interface `VNHInteractable` để vào ghế lái.
- Controller chuyển quyền điều khiển từ nhân vật sang xe.
- Có gia tốc, tốc độ tối đa, phanh, lùi và đánh lái theo tốc độ.
- Camera bám phía sau bằng SpringArm.
- Khi xuống xe, nhân vật được đặt cạnh xe và controller chuyển lại.
- API BlueprintCallable `SetVehicleInput`, `SetBrake`, `ExitVehicle` để nối với nút cảm ứng.

## Điều khiển bàn phím
- W/S: tiến/lùi.
- A/D: đánh lái.
- Space: phanh.
- F: xuống xe.
- E: nhìn vào xe và tương tác để vào xe (khi đang điều khiển nhân vật).

## Cách dùng trong Editor
1. Compile module.
2. Tạo Blueprint subclass từ `AVNHVehiclePawn`, ví dụ `BP_TestCar`.
3. Đặt Blueprint vào level có collision mặt đất.
4. Chọn nhân vật, nhìn vào xe và nhấn E để vào xe.
5. Dùng W/A/S/D, Space và F để thử.
6. Trên mobile, nối joystick/nút ga/nút phanh/nút xuống xe với các hàm BlueprintCallable.

## Giới hạn và bước nâng cấp
- Mesh thân xe và bánh xe hiện là khối cơ bản của Unreal để kiểm tra luồng gameplay.
- Chưa có skeletal vehicle mesh, suspension, bánh xe quay, vật lý Chaos Vehicles, xe máy, âm thanh động cơ, va chạm giao thông hoặc AI traffic.
- Chưa có UI mobile và chưa compile/test trên thiết bị. Không dùng thông số hiện tại làm mô phỏng vận hành xe ngoài đời.
