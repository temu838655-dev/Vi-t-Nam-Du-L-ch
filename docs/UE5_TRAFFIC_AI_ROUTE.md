# Giao thông AI – chạy theo tuyến spline

## Phạm vi hiện tại
Bộ khung này cho phép Pawn xe thử nghiệm tự chạy theo một tuyến spline khép kín. Nó dùng bộ điều khiển arcade hiện có, không phải mô phỏng giao thông hoặc vật lý xe hoàn chỉnh.

## Thành phần
- `AVNHTrafficRoute`: Actor chứa Spline Component làm tuyến đường.
- `AVNHTrafficAIController`: tính hướng tới điểm nhìn trước trên spline, điều chỉnh lái và giảm ga khi góc cua lớn.
- `AVNHVehiclePawn`: tự nhận AI Controller khi đặt trong level; có thể được người chơi tương tác để chiếm quyền lái. Khi người chơi xuống xe, AI controller được tạo lại để xe tiếp tục chạy theo tuyến.

## Thiết lập trong Unreal Editor
1. Compile C++ module.
2. Tạo Blueprint subclass từ `AVNHTrafficRoute`, ví dụ `BP_Route_OldQuarter`.
3. Đặt route vào level. Trong Spline Component, thêm ít nhất 3–4 spline points theo tim một làn đường, theo đúng chiều lưu thông; đóng vòng tuyến.
4. Tạo Blueprint subclass từ `AVNHVehiclePawn`, ví dụ `BP_TrafficCar`.
5. Đặt xe vào level và gán trường `Traffic Route` tới route vừa tạo.
6. Đặt xe hướng cùng chiều với spline tại vị trí xuất phát.
7. Đảm bảo tuyến đường thông thoáng và không có vật cản chặn xe. Chạy Play để quan sát.

## Điều khiển người chơi
- Khi xe đang được AI điều khiển, người chơi có thể nhìn vào xe và nhấn E để chiếm quyền lái.
- W/S ga và lùi; A/D đánh lái; Space phanh; F xuống xe.
- Khi xuống xe, xe chuyển lại cho AI và tiếp tục bám tuyến.

## Giới hạn quan trọng
- Đây là bộ khung chạy theo một spline, chưa phải hệ thống giao thông đô thị.
- Chưa có nhiều làn, đèn giao thông, biển báo, ưu tiên giao lộ, nhường đường, tránh va chạm, dừng đèn đỏ, xe máy, xe buýt, taxi hoặc hành vi giao thông Việt Nam.
- Chưa có hệ thống sinh/despawn xe theo khoảng cách người chơi; không nên đặt số lượng lớn.
- Mô hình xe vẫn là khối placeholder, chuyển động arcade và chưa dùng Chaos Vehicles.
- Phải có spline hợp lệ và kiểm thử trong Unreal Editor; mã nguồn chưa được compile hoặc chạy trên thiết bị.
