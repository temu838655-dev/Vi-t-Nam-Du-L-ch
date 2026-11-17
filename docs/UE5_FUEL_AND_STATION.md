# Nhiên liệu và trạm xăng – prototype

## Nhiên liệu phương tiện
`AVNHVehiclePawn` có:
- `FuelCapacity`: dung tích nhiên liệu tối đa.
- `CurrentFuel`: lượng nhiên liệu hiện tại.
- `FuelConsumptionPerSecond`: mức tiêu thụ cơ bản theo thời gian chạy.
- `GetFuelPercent()`: giá trị 0–1 để UI hiển thị thanh nhiên liệu.
- `Refuel(Amount)`: nạp thêm nhiên liệu, không vượt dung tích tối đa và trả về lượng thực tế đã nạp.

Khi hết nhiên liệu, xe không thể tăng tốc và giảm tốc về 0. Xe máy prototype có dung tích mặc định 8 đơn vị và mức tiêu thụ 0,025 đơn vị/giây khi chạy; ô tô nền tảng mặc định 45 đơn vị và mức tiêu thụ 0,018 đơn vị/giây. Đây là thông số gameplay thử nghiệm, không đại diện định mức tiêu hao thực tế. Blueprint event chỉ được gọi khi thực sự nạp thêm nhiên liệu; xe đã đầy bình không phát thông báo nạp thành công.

## Trạm xăng
`AVNHFuelStation` là Actor tương tác được qua `VNHInteractable`. Khi người chơi tương tác với trạm, hệ thống tìm xe `AVNHVehiclePawn` gần nhất trong bán kính `InteractionRadius` (mặc định 500 cm) và nạp `FuelPerInteraction` (mặc định 15 đơn vị). Blueprint event `OnFuelDispensed` có thể cập nhật thông báo, giao diện thanh toán hoặc âm thanh.

## Thiết lập trong Editor
1. Compile module.
2. Tạo Blueprint subclass từ `AVNHFuelStation`, ví dụ `BP_FuelStation`.
3. Đặt trạm cạnh khu vực đỗ xe; thay mesh blockout bằng mô hình trạm xăng được cấp phép.
4. Đảm bảo xe đỗ trong bán kính tương tác và collision của xe chặn kênh Visibility.
5. Khi người chơi rời xe, đứng gần trạm và nhấn nút tương tác (E trong cấu hình bàn phím).
6. Trong Blueprint, triển khai `OnFuelDispensed` để hiện lượng xăng được nạp và chi phí.

## Giới hạn
- Chưa có ví tiền, giá xăng, hóa đơn hoặc thanh toán.
- Chưa có hoạt ảnh vòi bơm, âm thanh, loại nhiên liệu hoặc trạm sạc xe điện.
- Tương tác nạp theo từng lần, chưa có thao tác giữ nút hoặc bơm theo thời gian.
- Chưa có giao diện HUD nhiên liệu.
- Cần kiểm tra collision, trace tương tác và compile trong Unreal Editor; chưa kiểm thử trên thiết bị.
