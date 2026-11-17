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
`AVNHFuelStation` là Actor tương tác được qua `VNHInteractable`. Khi người chơi tương tác với trạm, hệ thống tìm xe `AVNHVehiclePawn` gần nhất trong bán kính `InteractionRadius` (mặc định 500 cm). Trạm tính lượng nhiên liệu có thể mua dựa trên `FuelPerInteraction`, dung tích còn trống và số tiền trong ví; giá mặc định là 25.000 VND/đơn vị (`PricePerFuelUnit`). Người chơi có thể nạp một phần nếu tiền không đủ mua lượng tối đa. `OnFuelDispensed` nhận xe, lượng đã nạp và số tiền thực trả; `OnFuelPurchaseFailed` báo không có xe, bình đầy, thiếu tiền hoặc giao dịch thất bại.

## Thiết lập trong Editor
1. Compile module.
2. Tạo Blueprint subclass từ `AVNHFuelStation`, ví dụ `BP_FuelStation`.
3. Đặt trạm cạnh khu vực đỗ xe; thay mesh blockout bằng mô hình trạm xăng được cấp phép.
4. Đảm bảo xe đỗ trong bán kính tương tác và collision của xe chặn kênh Visibility.
5. Khi người chơi rời xe, đứng gần trạm và nhấn nút tương tác (E trong cấu hình bàn phím).
6. Hồ sơ mới sẽ có 100.000 VND; có thể điều chỉnh số tiền khởi tạo trong `UVNHSaveSubsystem::LoadOrCreateProgress`.
7. Trong Blueprint, triển khai `OnFuelDispensed` để hiện lượng xăng được nạp và chi phí; triển khai `OnFuelPurchaseFailed` để hiện lý do giao dịch không thành công.

## Giới hạn
- Đã có ví tiền cục bộ lưu trong SaveGame, giao dịch trừ tiền khi đổ xăng và hoàn tiền phần chênh lệch nếu nạp ít hơn báo giá; hồ sơ mới được khởi tạo 100.000 VND. Chưa có hóa đơn, lịch sử giao dịch hoặc UI ví.
- Chưa có hoạt ảnh vòi bơm, âm thanh, loại nhiên liệu hoặc trạm sạc xe điện.
- Tương tác nạp theo từng lần, chưa có thao tác giữ nút hoặc bơm theo thời gian.
- Chưa có giao diện HUD nhiên liệu.
- Cần kiểm tra collision, trace tương tác và compile trong Unreal Editor; chưa kiểm thử trên thiết bị.
