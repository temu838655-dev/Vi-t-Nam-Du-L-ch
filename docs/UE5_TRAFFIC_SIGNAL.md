# Đèn tín hiệu giao thông – bản nền tảng

## Chức năng
`AVNHTrafficSignal` là Actor đèn tín hiệu có ba trạng thái luân phiên:
- Xanh: cho xe đi.
- Vàng: yêu cầu xe dừng.
- Đỏ: yêu cầu xe dừng.

Thời lượng từng pha có thể chỉnh trong Details:
- Green Duration: mặc định 12 giây.
- Yellow Duration: mặc định 3 giây.
- Red Duration: mặc định 12 giây.

Actor có vùng dừng (StopZone). Khi Pawn xe thuộc `AVNHVehiclePawn` đi vào vùng này, xe nhận trạng thái dừng; khi đèn chuyển xanh, xe được phép chạy tiếp. Xe máy thử nghiệm kế thừa lớp này nên cũng nhận được lệnh dừng.

## Thiết lập
1. Compile C++ module.
2. Tạo Blueprint subclass từ `AVNHTrafficSignal`, ví dụ `BP_TrafficLight`.
3. Đặt vào level gần vạch dừng. Actor root là StopZone; điều chỉnh kích thước vùng sao cho xe có đủ khoảng cách giảm tốc.
4. Chỉnh vị trí actor để vùng overlap nằm trên hướng tiếp cận của làn xe.
5. Chỉnh thời lượng xanh/vàng/đỏ và trạng thái ban đầu.
6. Đặt xe AI có tuyến spline đi qua vùng dừng; chạy Play để kiểm tra.

## Giới hạn
- Đèn hiện là ba Point Light đại diện, chưa có mô hình cột đèn, chụp đèn, bảng đếm ngược hoặc vật liệu emissive.
- Mỗi Actor hoạt động như một tín hiệu độc lập; chưa đồng bộ pha giữa các hướng của giao lộ.
- Chưa phân biệt làn rẽ trái/rẽ phải, vạch dừng theo làn, ưu tiên xe cứu thương, đèn cho người đi bộ hoặc quy tắc giao thông Việt Nam.
- Vùng overlap đơn giản không phải hệ thống điều phối giao lộ; cần đặt đúng vị trí và kiểm thử tránh dừng nhầm.
- Chưa compile hoặc test trong Unreal Editor/thiết bị.
