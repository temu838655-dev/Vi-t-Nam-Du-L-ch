# Điểm tham quan tương tác (POI)

## Mã nguồn
AVNHPOIActor triển khai interface VNHInteractable để nhân vật có thể nhìn vào và tương tác bằng phím E hoặc gọi TryInteract từ UI cảm ứng.

Mỗi POI có:
- PointId: mã định danh ổn định, ví dụ HN_HOAN_KIEM_TURTLE_TOWER.
- DisplayName: tên địa điểm hiển thị.
- Description: mô tả ngắn.
- OnPointOfInterestInteracted: sự kiện Blueprint để mở bảng thông tin, nhiệm vụ hoặc hội thoại.

## Thiết lập trong Unreal Editor
1. Compile module C++.
2. Tạo Blueprint subclass từ AVNHPOIActor, ví dụ BP_POI_TurtleTower.
3. Đặt PointId, DisplayName và Description trong Details.
4. Trong Event Graph, triển khai OnPointOfInterestInteracted để mở Widget thông tin.
5. Đặt actor trong level gần địa danh tương ứng.
6. Đảm bảo vật thể có collision chặn kênh Visibility để line trace của nhân vật nhận diện được.

## Lưu ý
Mesh khối hộp chỉ là placeholder để kiểm tra luồng tương tác. Chưa có UI thông tin, dữ liệu lịch sử đã xác minh, voice-over hoặc mô hình 3D địa danh.
