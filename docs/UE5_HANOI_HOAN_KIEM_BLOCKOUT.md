# Khu vực thử nghiệm Hà Nội – Hồ Hoàn Kiếm

## Mục tiêu
Tạo khung không gian ban đầu để kiểm tra tỷ lệ nhân vật, camera, di chuyển và hướng mở rộng bản đồ. Đây chưa phải bản đồ địa lý chính xác hoặc mô hình Hồ Gươm hoàn chỉnh.

## Actor đã thêm
- AVNHHanoiPrototypeArea tạo mặt hồ dạng hình trụ dẹt, bốn hành lang đường bao quanh, khối Tháp Rùa giản lược và bốn cụm khối nhà phố.
- Actor dùng mesh cơ bản có sẵn trong Unreal Engine (/Engine/BasicShapes).
- Tọa độ hiện tại chỉ là blockout centimet, không phải tọa độ GIS hoặc kích thước khảo sát.

## Cách xem trong Unreal Editor
1. Mở Unreal/VietNamHanhTrinh.uproject bằng phiên bản Unreal Engine tương thích với EngineAssociation.
2. Biên dịch module C++ trong Editor hoặc IDE.
3. Tạo level mới và lưu tại Content/Maps/L_Hanoi_HoanKiem_Blockout.
4. Kéo actor VNHHanoiPrototypeArea từ Place Actors vào level.
5. Đặt PlayerStart ở khu vực đường phố phía tây hồ.
6. Chọn VNHGameMode làm GameMode Override của level và chạy thử.
7. Bổ sung nền sàn lớn bên dưới nếu level chưa có ground hoặc Landscape.

## Để đạt độ chân thực
- Thay mặt hồ blockout bằng địa hình bờ hồ và mặt nước có vật liệu PBR.
- Dựng Tháp Rùa, Đền Ngọc Sơn, cầu Thê Húc và phố cổ bằng tài sản 3D tự dựng hoặc được cấp phép.
- Dùng dữ liệu GIS có giấy phép phù hợp để định vị đường, vỉa hè và công trình.
- Bổ sung cây, đèn đường, biển hiệu tiếng Việt, xe máy, người đi bộ và âm thanh môi trường.
- Kiểm tra va chạm, LOD, texture streaming, nhiệt độ và FPS trên thiết bị Android/iOS thật.

## Giới hạn hiện tại
Commit chỉ thêm mã nguồn actor blockout. Chưa có file level .umap, mesh chi tiết, vật liệu nước, cây, NPC hoặc dữ liệu GIS. Cần Unreal Editor để biên dịch và đặt actor vào level.
