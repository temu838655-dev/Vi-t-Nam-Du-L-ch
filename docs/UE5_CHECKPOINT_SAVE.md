# Lưu vị trí hành trình và điểm tiếp tục

Checkpoint chỉ là dữ liệu kỹ thuật để tiếp tục hành trình; **không phải cơ chế hồi sinh và không phải vòng lặp chính của game**. Trò chơi tập trung vào mô phỏng cuộc sống: nhân vật có nhà, bố mẹ, nghề nghiệp tự chọn và tự do du lịch.

## API đã có

`UVNHSaveSubsystem::SaveCheckpoint(RegionId, CheckpointId)` là hàm BlueprintCallable để lưu vị trí/điểm dừng logic hiện tại vào SaveGame cục bộ.

- `RegionId`: mã khu vực ổn định, ví dụ `HANOI_HOAN_KIEM`.
- `CheckpointId`: mã điểm dừng ổn định, ví dụ `HO_GUOM_SOUTH_GATE`.
- Từ chối mã rỗng (`NAME_None`).
- Chỉ trả về `true` khi dữ liệu được ghi thành công.

## Quy tắc sử dụng trong gameplay

- **Chơi mới:** bắt đầu tại nhà gia đình của nhân vật.
- **Tiếp tục:** tải vị trí hành trình gần nhất đã lưu nếu vị trí đó hợp lệ.
- **Về nhà:** là lựa chọn tự do của người chơi; nhà là nơi ở lâu dài, không phải điểm bị ép quay về mỗi lần thoát game.
- **Checkpoint du lịch:** chỉ dùng để tiếp tục hành trình, không tự biến thành điểm hồi sinh ở địa điểm tham quan.
- **Vị trí lỗi/không hợp lệ:** dùng nhà gia đình làm điểm xuất hiện an toàn dự phòng.

## Dữ liệu đời sống tách biệt

Save schema v2 lưu riêng:
- `HomeRegionId`, `HomeLocationId`: nhà ở cố định.
- `MotherCharacterId`, `FatherCharacterId`: danh tính bố mẹ/NPC gia đình.
- `SelectedJobId`, `WorkplaceId`, `MonthlySalary`, `CompletedWorkShifts`: nghề và tiến trình làm việc.
- `CurrentRegionId`, `LastCheckpointId`: vị trí hành trình hiện tại.

## Giới hạn hiện tại

API mới lưu các ID; chưa tự ánh xạ ID thành Actor/Transform, chưa tự dựng nhà, bố mẹ, lịch sinh hoạt hoặc nghề nghiệp. Blueprint/GameMode cần thực hiện việc chọn vị trí xuất hiện theo quy tắc trên. Tài khoản Google/Apple và đồng bộ đám mây chưa được triển khai. Chưa compile hoặc chạy thử trong Unreal Editor 5.8.

Thiết kế tổng thể: [Mô phỏng cuộc sống Việt Nam](UE5_LIFE_SIMULATION_DESIGN.md).
