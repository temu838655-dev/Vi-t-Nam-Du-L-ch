# Vertical slice bootstrap – map thử nghiệm đầu tiên

## Cách hoạt động
AVNHGameMode::InitGame kiểm tra map hiện tại. Nếu chưa có AVNHHanoiPrototypeArea, GameMode tự spawn blockout Hồ Hoàn Kiếm. Nếu map chưa có APlayerStart, GameMode tạo điểm bắt đầu dự phòng ở bờ nam hồ (X=0, Y=-5800, Z=100 cm). Nếu level đã có actor do người thiết kế đặt, hệ thống giữ nguyên và không tạo bản trùng.

Ground blockout dùng Basic Cube scale 400 x 320, tương ứng khoảng 400 m x 320 m; mặt trên đặt ở Z=0. Đây vẫn là greybox tỷ lệ gameplay, không phải dữ liệu khảo sát địa lý.

## Chạy thử trong Unreal Editor
1. Mở Unreal/VietNamHanhTrinh.uproject bằng Unreal Engine 5.8.
2. Generate project files và compile module C++.
3. Tạo một level mới trong Content Browser và lưu trong thư mục Content của project.
4. Mở World Settings, chọn GameMode Override là VNHGameMode nếu project chưa dùng GlobalDefaultGameMode.
5. Nhấn Play. GameMode sẽ tự tạo blockout và PlayerStart nếu level chưa có hai actor đó.
6. Nếu muốn dùng HUD cảm ứng, tạo WBP_MobileHUD từ parent VNHMobileHUDWidget và cấu hình qua Blueprint subclass của VNHPlayerController; xem docs/UE5_MOBILE_UMG_SETUP.md.

## Giới hạn
- Repository chưa có file map .umap do Unreal Editor tạo; người dùng vẫn phải tạo/lưu level đầu tiên trong Editor.
- Greybox dùng Basic Shapes, chưa phải mô hình Hồ Gươm chính xác hoặc tài sản 3D hoàn thiện.
- Tự động spawn không thay thế việc thiết kế địa hình, NavMesh, tuyến đường, ánh sáng, vật liệu và tối ưu hóa.
- Chưa compile hoặc chạy Play trong Unreal Editor ở môi trường hiện tại; cần xác nhận trên máy có UE5.8.