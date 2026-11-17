# Giao diện, đăng nhập và lưu tiến trình

## Luồng khởi động
- Cài mới/chưa có dữ liệu: hiển thị BẮT ĐẦU và ĐĂNG NHẬP GOOGLE.
- Đã có dữ liệu khách: hiển thị TIẾP TỤC, CHƠI MỚI và ĐĂNG NHẬP GOOGLE.
- Tiến trình khách được lưu cục bộ bằng ConfigFile tại user://player_progress.cfg.
- Khi có phiên Google đã xác thực và được liên kết thật, game mới được phép tự khôi phục và vào thẳng.

## Ranh giới tích hợp Google
Nút Google trong prototype hiện thông báo trạng thái chưa cấu hình. Không giả lập đăng nhập thành công. Muốn bật đăng nhập thật cần OAuth client ID cho Android, cấu hình SHA-1/SHA-256 của khóa ký, triển khai Google Identity Services và dịch vụ cloud save có xác thực. Không đưa client secret hoặc khóa riêng vào repository.

## HUD theo ảnh tham khảo
HUD mục tiêu gồm hồ sơ/level, tiền và vật phẩm, nhiệm vụ khám phá, bản đồ mini, joystick trái, camera kéo 360 độ, nhảy, túi đồ và tương tác. Trò chơi du lịch không dùng nút tấn công như hành động mặc định.

## Tính đúng chất Việt Nam
Mỗi địa phương phải có gói nội dung được kiểm chứng: ảnh tham chiếu có quyền sử dụng, tọa độ, đường phố/địa danh, kiến trúc, biển báo, phương tiện, biển số, trang phục và sinh hoạt. Ưu tiên hoàn thiện một khu vực mẫu Hà Nội trước khi mở rộng. Không thay thế dữ liệu thực bằng mô hình khối hoặc phong cảnh chung rồi gắn nhãn địa danh.
