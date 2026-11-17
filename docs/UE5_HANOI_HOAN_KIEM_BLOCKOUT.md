# Khu vực thử nghiệm Hà Nội – Hồ Hoàn Kiếm

## Mục tiêu
Tạo khung không gian đầu tiên để kiểm tra tỷ lệ nhân vật, camera, di chuyển và tương tác tại địa điểm du lịch. Đây là greybox để thử gameplay, không phải bản đồ địa lý chính xác hoặc mô hình hoàn chỉnh.

## Thành phần blockout
Actor `AVNHHanoiPrototypeArea` tạo:
- Nền thử nghiệm khoảng 400 m x 320 m.
- Mặt hồ hình trụ dẹt khoảng 160 m x 100 m, chỉ là hình khối thay thế nước.
- Bốn tuyến đường bao quanh và các dải vỉa hè đơn giản.
- Khối Tháp Rùa, khối Đền Ngọc Sơn và cầu Thê Húc ở mức dựng khối.
- Bốn khối nhà phố đại diện khu phố cổ.

Tất cả tọa độ dùng đơn vị centimet của Unreal, được đặt để kiểm tra camera và tỷ lệ. Chúng không phải tọa độ GIS hoặc kích thước đo đạc thực tế.

## Điểm tham quan có thể tương tác
Dùng `AVNHPOIActor` để tạo các điểm như:
- `HN_HOAN_KIEM_TURTLE_TOWER`
- `HN_NGOC_SON_TEMPLE`
- `HN_THE_HUC_BRIDGE`

Đặt tên và mô tả trong Details. Blueprint subclass có thể triển khai sự kiện `OnPointOfInterestInteracted` để mở bảng thông tin.

## Cách xem trong Unreal Editor
1. Mở `Unreal/VietNamHanhTrinh.uproject` bằng Unreal Engine tương thích với `EngineAssociation`.
2. Biên dịch module C++.
3. Tạo level mới tại `Content/Maps/L_Hanoi_HoanKiem_Blockout`.
4. Kéo actor `VNHHanoiPrototypeArea` vào level.
5. Đặt PlayerStart ở tuyến đường phía tây hoặc phía nam hồ, cao hơn mặt nền.
6. Đặt một số Blueprint POI tại các địa danh.
7. Chọn `VNHGameMode` làm GameMode Override và chạy thử.

## Việc cần làm để đạt độ chân thực
- Thay khối hồ bằng địa hình bờ hồ và vật liệu nước PBR.
- Dựng chi tiết Tháp Rùa, Đền Ngọc Sơn, cầu Thê Húc và nhà phố bằng tài sản 3D tự tạo hoặc có giấy phép.
- Dùng dữ liệu GIS có giấy phép phù hợp để định vị đường, vỉa hè và công trình.
- Bổ sung cây, đèn đường, biển hiệu tiếng Việt, xe máy, người đi bộ và âm thanh môi trường.
- Kiểm thử collision, LOD, texture streaming, nhiệt độ và FPS trên Android/iOS thật.

## Giới hạn hiện tại
Repository có mã nguồn actor blockout và hệ thống POI tương tác cơ bản. Chưa có file level `.umap`, mesh chi tiết, vật liệu nước, cây, NPC, dữ liệu GIS hoặc UI thông tin địa điểm. Cần Unreal Editor để biên dịch, tạo level và đặt actor.
