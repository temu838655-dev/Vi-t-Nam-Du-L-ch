# Lưu checkpoint theo khu vực

## API đã có

`UVNHSaveSubsystem::SaveCheckpoint(RegionId, CheckpointId)` là hàm BlueprintCallable để lưu vị trí tiến trình logic của người chơi vào SaveGame cục bộ.

- `RegionId`: mã khu vực ổn định, ví dụ `HANOI_HOAN_KIEM`.
- `CheckpointId`: mã checkpoint ổn định, ví dụ `HO_GUOM_SOUTH_GATE`.
- Từ chối mã rỗng (`NAME_None`).
- Chỉ trả về `true` khi dữ liệu đã được ghi thành công bằng SaveGameToSlot.
- Ghi nhận revision và thời điểm UTC thông qua `SaveProgress` hiện có.

## Cách nối trong Blueprint

1. Từ một Actor checkpoint hoặc sự kiện hoàn thành điểm tham quan, lấy Game Instance.
2. Gọi `Get Subsystem` với class `VNHSaveSubsystem`.
3. Gọi `SaveCheckpoint`, truyền mã khu vực và mã checkpoint cố định.
4. Chỉ hiện thông báo “Đã lưu điểm dừng” khi kết quả trả về là `true`.
5. Khi tải game, gọi `LoadProgress` và đọc `CurrentRegionId`, `LastCheckpointId` từ SaveGame để quyết định vị trí hồi sinh.

## Giới hạn hiện tại

API này lưu ID checkpoint/khu vực, chưa tự tìm Actor tương ứng hoặc dịch chuyển nhân vật khi tải game. Blueprint/GameMode vẫn cần ánh xạ ID sang Transform spawn hợp lệ. Cloud sync, tài khoản Google/Apple và xung đột nhiều thiết bị chưa được triển khai. Chưa compile hoặc chạy thử trong Unreal Editor 5.8.
