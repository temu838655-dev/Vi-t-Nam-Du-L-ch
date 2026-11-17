# Xe máy – Pawn thử nghiệm

## Mã nguồn
- `AVNHMotorbikePawn` kế thừa điều khiển arcade, vào/ra xe, AI bám spline và giao diện input từ `AVNHVehiclePawn`.
- Tạo hình blockout gồm thân xe hẹp, yên, bình xăng, tay lái, phuộc trước và hai bánh.
- Thông số tốc độ/đánh lái riêng cho xe máy; bánh xe thứ ba và thứ tư của mẫu ô tô được ẩn.

## Cách dùng
1. Compile module.
2. Tạo Blueprint subclass từ `AVNHMotorbikePawn`, ví dụ `BP_Motorbike_Test`.
3. Đặt Blueprint vào level; gán `Traffic Route` nếu muốn AI chạy tuyến.
4. Nếu chạy AI, kiểm tra route spline có chiều chạy hợp lý và không cắt vật cản.
5. Nhấn Play; người chơi có thể nhìn xe và nhấn E để điều khiển.
6. W/S ga/lùi, A/D đánh lái, Space phanh, F xuống xe.
7. Trên mobile, nối joystick/ga/phanh/xuống xe vào các hàm BlueprintCallable kế thừa.

## Giới hạn
- Hình xe chỉ là khối dựng từ BasicShapes, không phải mẫu xe máy thương mại.
- Chưa có skeletal mesh, người lái, tư thế ngồi, animation nghiêng xe, hệ thống cân bằng hai bánh, âm thanh, va chạm thực tế, đèn xi-nhan hoặc mô phỏng Chaos.
- AI dùng cùng bộ điều khiển bám spline của xe ô tô; chưa có hành vi luồn lách, vượt xe hay tuân thủ luật giao thông.
- Chưa có UI mobile, map level hoặc kiểm thử biên dịch/thiết bị.
