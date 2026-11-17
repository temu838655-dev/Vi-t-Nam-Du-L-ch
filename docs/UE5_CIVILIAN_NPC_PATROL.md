# NPC người dân – tuần tra cơ bản

## Mã nguồn
- `AVNHCivilianCharacter`: nhân vật NPC, có tốc độ đi bộ, tên hiển thị, cờ cho phép hội thoại và danh sách điểm tuần tra.
- `AVNHCivilianAIController`: điều khiển NPC di chuyển tuần tự giữa các điểm tuần tra, tạm dừng ngẫu nhiên 1–3 giây ở mỗi điểm.

## Cách thiết lập trong Unreal Editor
1. Compile C++ module sau khi cài các module AIModule và NavigationSystem.
2. Tạo Blueprint subclass từ `AVNHCivilianCharacter`, ví dụ `BP_Civilian_Adult`.
3. Gán Skeletal Mesh người, Animation Blueprint và capsule/collision phù hợp trong Blueprint.
4. Đặt NPC vào level.
5. Trong Details > VNH Civilian > Patrol Points, thêm ít nhất hai tọa độ tuần tra (tọa độ world, centimet).
6. Trong Event Graph, triển khai `OnCivilianInteracted` để mở widget hội thoại hoặc lựa chọn nhiệm vụ.
7. Thêm Nav Mesh Bounds Volume bao phủ vỉa hè/khu đi bộ.
8. Nhấn P trong viewport để xem vùng NavMesh màu xanh lá; build navigation nếu cần.
9. Chạy Play để NPC tuần tra giữa các điểm.

## Lưu ý
- NPC chưa tự sinh ra; đặt Blueprint NPC vào level hoặc tạo spawner ở giai đoạn sau.
- Không có mesh/animation người thật trong repository; cần tài sản 3D tự tạo hoặc được cấp phép.
- Chưa có hội thoại, lịch sinh hoạt, né tránh đám đông, giao thông AI, tối ưu số lượng NPC hoặc kiểm thử trên điện thoại.
- Nếu không có NavMesh, NPC sẽ không tìm được đường đi.
