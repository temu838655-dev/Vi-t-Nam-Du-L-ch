# Đồng hồ và lịch trong game

## Mục tiêu

Thời gian của thế giới game độc lập với giờ thực trên điện thoại. Lưu trữ ngày trong game, phút trong ngày và thứ trong tuần để lịch gia đình, công việc, cửa hàng và giao thông có thể dùng chung một nguồn thời gian.

## Quy ước

- Ngày bắt đầu: Day 1.
- Thứ bắt đầu: Monday, chỉ số 0; Tuesday=1, ... Sunday=6.
- Giờ bắt đầu New Game: 08:00 (480 phút sau nửa đêm).
- MinuteOfDay nằm trong 0–1439.
- Một ngày game có 1440 phút.

## API

### `AdvanceGameMinutes(MinutesToAdvance)`

Chỉ chấp nhận số phút dương. API xử lý qua ngày và tuần, cập nhật SaveGame rồi lưu ngay. Ví dụ:
- `AdvanceGameMinutes(30)`: tiến 30 phút.
- `AdvanceGameMinutes(480)`: tiến 8 giờ.
- `AdvanceGameMinutes(1440)`: sang ngày tiếp theo, giữ nguyên giờ.

Các sự kiện gameplay như ngủ, ca làm, chuyến xe hoặc hoạt động dài có thể gọi API này. Không nên gọi mỗi frame; đây là API tiến thời gian theo sự kiện. Khi cần đồng hồ chạy liên tục theo thời gian thực, Game Time Driver riêng sẽ tích lũy delta và gọi API theo từng bước phù hợp.

### `GetGameClock(OutGameDay, OutMinuteOfDay, OutWeekdayIndex)`

Đọc ngày, phút trong ngày và thứ trong tuần đã lưu. Chuyển phút thành giờ/phút bằng phép chia cho 60 và phần dư.

## Tích hợp lịch gia đình

Gọi `GetGameClock`, sau đó truyền `OutMinuteOfDay` vào `GetFamilyActivityAtTime`. Như vậy NPC gia đình và các hệ thống gameplay dùng cùng thời gian. Bước kế tiếp là Game Time Driver, đồng bộ cập nhật AI/animation/UI theo lịch.

## Migration

SaveGame nâng lên schema v5. Save cũ được gán ngày 1, 08:00, thứ Hai khi không có dữ liệu lịch. Tiền, nghề nghiệp, vị trí và lịch gia đình không bị đặt lại.

## Giới hạn

Đây là lịch game lưu theo sự kiện, chưa phải đồng hồ tự chạy mỗi giây. Chưa có UI đồng hồ, ngày lễ, mùa, thời tiết theo thời gian, lịch cuối tuần hoặc AI tự đổi vị trí. Chưa xác nhận compile/runtime trong Unreal Engine 5.8.
