# Save, account và đồng bộ dữ liệu

## Trạng thái triển khai
- Có lớp dữ liệu UVNHSaveGame với schema version.
- Có UVNHSaveSubsystem để lưu, tải, kiểm tra và xóa save cục bộ.
- Chưa có backend cloud, đăng nhập Google/Apple hoặc kiểm thử trên thiết bị thật.

## Nguyên tắc
- Dùng ID ổn định cho vùng, checkpoint, nhiệm vụ và vật phẩm; không lưu con trỏ UObject hay tên hiển thị đã bản địa hóa.
- SchemaVersion dành cho migration khi cập nhật game.
- LocalRevision tăng sau mỗi lần lưu; thời điểm lưu dùng UTC ISO-8601.
- Không lưu mật khẩu, access token hoặc refresh token trong SaveGame.
- Nếu save có schema mới hơn bản game, không tự ghi đè dữ liệu.

## Luồng dự kiến
1. Khởi động: kiểm tra save cục bộ.
2. Chưa có save: hiển thị Bắt đầu / Đăng nhập.
3. Có save: hiển thị Tiếp tục / Chơi mới.
4. Offline: lưu cục bộ trước, đánh dấu thay đổi chờ đồng bộ.
5. Đăng nhập: xác thực qua adapter nền tảng; chỉ liên kết hồ sơ khách sau khi người chơi xác nhận.
6. Cloud: so sánh revision, tạo bản sao an toàn khi xung đột rồi mới áp dụng dữ liệu.
7. Đăng xuất không tự xóa save cục bộ.

## Phân lớp
- Identity Provider: Google Sign-In trên Android, Sign in with Apple trên iOS.
- Player Profile: ID người chơi độc lập với nhà cung cấp đăng nhập.
- Cloud Save API: giao diện trung lập nhà cung cấp; backend chưa được chọn.
- Local Save: luôn hoạt động độc lập khi mất mạng.

Không tuyên bố cloud save hoạt động trước khi backend, xác thực, xử lý xung đột và kiểm thử phục hồi hoàn tất.
