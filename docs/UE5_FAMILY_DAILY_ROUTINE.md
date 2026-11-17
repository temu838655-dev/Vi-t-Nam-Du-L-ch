# Lịch sinh hoạt hằng ngày của gia đình

## Mục tiêu

Bố mẹ và thành viên gia đình có lịch theo giờ trong game. Lịch lưu theo phút từ 00:00 đến 24:00, không phụ thuộc giờ thực của điện thoại. Game Clock/World Time System sẽ truyền phút hiện tại vào API truy vấn.

## Dữ liệu

`FVNHDailyRoutineEntry` gồm:
- `StartMinute`: phút bắt đầu, 0–1439.
- `EndMinute`: phút kết thúc, tối đa 1440; thời điểm kết thúc không thuộc khoảng.
- `ActivityId`: mã hoạt động, ví dụ `ACT_EAT_BREAKFAST`, `ACT_WORK`, `ACT_REST`.
- `LocationId`: mã địa điểm, ví dụ `LOC_FAMILY_HOME_KITCHEN`, `LOC_WORKPLACE_01`.

Mỗi thành viên hỗ trợ tối đa 12 khoảng hoạt động mỗi ngày. Khoảng phải có thời lượng dương, có ID hoạt động/địa điểm và không được chồng lấn. Có thể để trống khoảng thời gian để biểu thị thời gian tự do/hoạt động mặc định.

## API Blueprint/C++

### Lưu lịch

`SetFamilyDailyRoutine(CharacterId, Routine)`

API sắp xếp lịch theo thời điểm bắt đầu, kiểm tra tính hợp lệ và lưu toàn bộ lịch cho thành viên. Nếu có khoảng chồng lấn hoặc dữ liệu sai, lịch cũ được giữ nguyên.

### Truy vấn hoạt động

`GetFamilyActivityAtTime(CharacterId, MinuteOfDay, OutActivityId, OutLocationId)`

Trả về true khi tìm thấy hoạt động chứa thời điểm truy vấn. Khoảng thời gian sử dụng quy tắc [StartMinute, EndMinute), tránh hai hoạt động cùng chiếm một phút giao nhau. Nếu không có hoạt động, trả về false và hai output là NAME_None.

## Ví dụ lịch mẫu

| Giờ | Hoạt động | Địa điểm |
|---|---|---|
| 06:00–07:00 | Thức dậy, chuẩn bị bữa sáng | Nhà – bếp |
| 07:00–08:00 | Ăn sáng cùng gia đình | Nhà – phòng ăn |
| 08:00–12:00 | Làm việc | Nơi làm việc |
| 12:00–13:00 | Ăn trưa | Quán ăn/cơ quan |
| 13:00–17:00 | Làm việc | Nơi làm việc |
| 18:00–20:00 | Về nhà, ăn tối | Nhà |
| 20:00–22:00 | Nghỉ ngơi, sinh hoạt | Nhà |

Đây là dữ liệu ví dụ để kiểm thử, không phải lịch cố định áp đặt lên mọi gia đình hoặc vùng miền. Lịch thực tế cần tùy chỉnh theo nghề nghiệp, ngày trong tuần, độ tuổi, ngày nghỉ và sự kiện.

## Schema và tương thích

SaveGame được nâng lên schema v4. Migration v1→v2→v3→v4 giữ nguyên tiền, nghề nghiệp và vị trí đã lưu. Lịch cũ được để trống có chủ đích; hệ thống gameplay có thể dùng hành vi mặc định cho đến khi lịch được thiết lập.

## Giới hạn

API hiện chỉ lưu và truy vấn lịch. Chưa có Game Clock hoàn chỉnh, AI tự di chuyển NPC giữa các địa điểm, animation, lịch ngày nghỉ, hệ thống sự kiện hoặc giao diện chỉnh lịch. Cần kiểm thử compile và runtime trong Unreal Engine 5.8 trước khi coi đây là tính năng hoạt động trong game.
