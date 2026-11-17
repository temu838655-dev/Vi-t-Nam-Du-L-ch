# Hệ thống tương tác địa điểm – POI

## Thành phần
- `UVNHInteractable` là interface để Actor trong thế giới có thể nhận tương tác.
- `AVNHPointOfInterest` là lớp cơ sở Blueprintable cho danh thắng, cửa hàng, bảng thông tin, điểm du lịch hoặc vật thể nhiệm vụ.
- Nhân vật thực hiện line trace từ camera trong phạm vi mặc định 350 cm; nếu Actor nhìn thấy triển khai interface thì gọi sự kiện `Interact`.
- Hàm `TryInteract()` có thể gọi từ nút tương tác trên HUD điện thoại; trên máy tính dùng phím E.

## Tạo một điểm tham quan trong Editor
1. Biên dịch C++ project.
2. Tạo Blueprint Class kế thừa `VNHPointOfInterest`.
3. Gán Static Mesh được cấp phép hoặc tự dựng vào component `Visual`.
4. Điền `PointOfInterestId`, `DisplayName` và `Description`.
5. Triển khai sự kiện `OnPointOfInterestInteracted` trong Event Graph để mở bảng thông tin, phát hội thoại hoặc bắt đầu nhiệm vụ.
6. Đặt collision của mesh chặn kênh Visibility để camera line trace nhận diện được.

## Lưu ý
- Hệ thống hiện chỉ phát sự kiện tương tác; chưa có giao diện popup, hội thoại, nhiệm vụ hoặc lưu trạng thái đã khám phá.
- Chưa gán mesh thật cho Hồ Gươm, Tháp Rùa hay Đền Ngọc Sơn.
- Phím E là điều khiển thử trên máy tính; HUD cảm ứng cần gọi `TryInteract()`.
- Chưa biên dịch bằng Unreal Editor trong môi trường này, vì vậy cần xác nhận build thực tế trước khi coi là đã kiểm thử.