# Luồng tạo cuộc sống mới và nghề nghiệp – UE5

## API hiện có

Lớp `UVNHSaveSubsystem` cung cấp các hàm BlueprintCallable:

- `CreateNewLife(NewPlayerId, StartingMoney, bReplaceExistingSave)`: tạo hồ sơ mới tại nhà gia đình ở Hà Nội, đặt bố mẹ mặc định, không chọn nghề thay người chơi.
- `LoadProgress()`: tải hồ sơ hiện có và nâng schema cũ lên phiên bản hiện tại.
- `SelectCareer(JobId, WorkplaceId, MonthlySalary)`: lưu lựa chọn nghề và nơi làm việc do UI/gameplay cung cấp.
- `ClearCareerSelection()`: xóa lựa chọn nghề.
- `SaveCheckpoint(RegionId, CheckpointId)`: lưu vị trí hành trình, không thay đổi nhà cố định.

## Bảo vệ dữ liệu

- Nếu đã có save, `CreateNewLife` trả về null khi `bReplaceExistingSave=false`.
- Chỉ truyền `true` sau khi người chơi xác nhận rõ ràng thao tác Chơi mới và đã được cảnh báo save cũ sẽ bị thay thế.
- Không tự động tạo hồ sơ mới trong `GetMoney`, `AddMoney`, `TrySpendMoney` hoặc `SaveCheckpoint` khi chưa có save. UI phải đi qua luồng tạo nhân vật/cuộc sống mới.
- Load save schema v1 sẽ bổ sung mặc định nhà và bố mẹ, giữ nguyên tiền và vị trí hành trình đã lưu, không tự gán nghề.
- Load save schema hiện tại không được ghi lại slot hoặc tăng revision ngoài ý muốn.
- Save schema mới hơn phiên bản game hiện tại bị từ chối để tránh ghi đè dữ liệu từ phiên bản mới.

## Luồng UI dự kiến

1. Màn hình đầu: Bắt đầu / Đăng nhập Google hoặc Apple (khi tích hợp xác thực).
2. Nếu có save: hiển thị Tiếp tục và Chơi mới.
3. Tiếp tục: gọi `LoadProgress`, sau đó world-location resolver xác thực vị trí; chỉ fallback về nhà gia đình nếu vị trí lưu không hợp lệ.
4. Chơi mới: hiển thị xác nhận thay thế save, tạo nhân vật, sau đó gọi `CreateNewLife`.
5. Sau phần mở đầu tại nhà, người chơi tự chọn nghề; UI chỉ gọi `SelectCareer` sau khi người chơi chọn công việc và nơi làm việc.
6. Không có nghề mặc định. Chưa chọn nghề thì nhân vật vẫn có thể sinh hoạt và khám phá theo phạm vi gameplay được mở.

## Giới hạn chưa triển khai

Các API trên mới là nền tảng lưu dữ liệu. Chưa có menu tạo nhân vật hoàn chỉnh, danh mục nghề đã cân bằng, bản đồ nơi làm việc, ca làm, lịch trả lương theo thời gian, bố mẹ NPC, nhà 3D hoặc xác thực Google/Apple. `MonthlySalary` hiện chỉ lưu mức lương cấu hình; chưa tự động cộng tiền theo tháng. Cần triển khai lịch mô phỏng và quy tắc trả lương riêng trước khi công bố hệ thống nghề nghiệp hoàn chỉnh.

## Kiểm thử bắt buộc trong Unreal Engine 5.8

- Tạo save mới khi chưa có dữ liệu.
- Gọi tạo mới lần nữa với overwrite=false và xác nhận save cũ còn nguyên.
- Chỉ overwrite khi đã xác nhận từ UI.
- Nạp save v1 giả lập, kiểm tra tiền/vị trí được giữ và nghề vẫn trống.
- Nạp save v2 nhiều lần, kiểm tra revision không tự tăng.
- Thử save version mới hơn và xác nhận game không ghi đè.
- Chạy kiểm thử trên Android/iOS sau khi module compile thành công.

Chưa có kết quả compile hoặc runtime test được xác nhận trong repository.
