# Việt Nam – Hành Trình Bất Tận

Game mô phỏng du lịch và đời sống Việt Nam theo hướng thế giới mở, phát hành mục tiêu đầu tiên trên Android và iPhone.

## Hướng công nghệ đã chốt
- **Engine chính:** Unreal Engine 5.
- **Nền tảng đầu tiên:** Android và iOS.
- **Godot prototype:** vẫn giữ ở thư mục gốc để tham chiếu, không còn là nền tảng phát triển game chính.
- **Unreal scaffold:** nằm trong thư mục `Unreal/`.

## Trạng thái thực tế
Repository có bộ khung UE5 C++ gồm GameMode, PlayerController, nhân vật góc nhìn thứ ba, camera, hàm điều khiển cảm ứng, lưu tiến trình cục bộ, trace tương tác và actor điểm tham quan (POI). Khu vực Hồ Hoàn Kiếm hiện có actor dựng khối greybox với nền, hồ, đường, vỉa hè và khối đại diện một số địa danh. Hệ thống POI có thể tương tác và Pawn phương tiện arcade thử nghiệm đã được thêm vào mã nguồn; phương tiện hỗ trợ vào/ra, ga, lùi, phanh, đánh lái và camera bám xe. Bộ khung NPC người dân có AI tuần tra giữa các điểm, interface tương tác và sự kiện Blueprint để mở hội thoại cũng đã được thêm; NPC cần Blueprint có mesh/animation và Nav Mesh để hoạt động. Xe ô tô thử nghiệm có thể chạy theo tuyến spline khép kín bằng AI controller; người chơi có thể chiếm quyền lái và trả xe lại cho AI khi xuống xe. Đã thêm Pawn xe máy blockout kế thừa điều khiển, tương tác và AI bám tuyến để làm nền cho phương tiện hai bánh. Actor đèn giao thông có pha xanh/vàng/đỏ và vùng dừng cho xe thử nghiệm cũng đã được thêm. Hệ thống nhiên liệu nền tảng đã có mức nhiên liệu, tiêu thụ khi chạy, dừng xe khi cạn và Actor trạm xăng tương tác để nạp cho phương tiện gần nhất.

Chưa xác nhận biên dịch bằng Unreal Editor. Chưa có level `.umap` đã tạo trong Editor, nhân vật 3D hoàn chỉnh, animation, mô hình địa danh chi tiết, xe cộ, NPC, đăng nhập Google/Apple, cloud save hoặc APK/IPA. Phương tiện hiện dùng mesh hình khối và chuyển động arcade, chưa phải mô phỏng Chaos Vehicles hay xe máy hoàn chỉnh. NPC mới chỉ có logic tuần tra cơ bản; chưa có mô hình người, animation, hội thoại hoặc hệ thống đám đông. AI giao thông mới chỉ chạy theo spline đơn giản; đèn tín hiệu mới có chu kỳ độc lập và vùng dừng cơ bản, chưa có đồng bộ giao lộ, ưu tiên làn, tránh va chạm hay hành vi xe máy Việt Nam. Nhiên liệu và trạm xăng mới là logic prototype, chưa có giá tiền, ví, HUD, hoạt ảnh bơm hoặc trạm sạc.

## Mở dự án Unreal
1. Cài Unreal Engine phiên bản tương thích với `EngineAssociation` trong project descriptor.
2. Mở `Unreal/VietNamHanhTrinh.uproject` trong Unreal Editor.
3. Generate project files và build C++ module.
4. Tạo map đầu tiên trong Content Browser, đặt actor `VNHHanoiPrototypeArea` vào map và cấu hình PlayerStart.
5. Cấu hình Android SDK/NDK và test trên thiết bị Android.
6. Build iOS cần máy Mac, Xcode và chứng chỉ ký ứng dụng.

## Kiến trúc và lộ trình
Xem [Kiến trúc Unreal Engine 5](docs/UE5_MOBILE_ARCHITECTURE.md), [Quy trình nội dung địa phương](docs/VIETNAM_CONTENT_PIPELINE.md), [Blockout Hồ Hoàn Kiếm](docs/UE5_HANOI_HOAN_KIEM_BLOCKOUT.md) và [POI tương tác](docs/UE5_POI_INTERACTION.md), [phương tiện thử nghiệm](docs/UE5_VEHICLE_PROTOTYPE.md), [NPC tuần tra](docs/UE5_CIVILIAN_NPC_PATROL.md), [AI giao thông theo spline](docs/UE5_TRAFFIC_AI_ROUTE.md), [xe máy thử nghiệm](docs/UE5_MOTORBIKE_PROTOTYPE.md), [đèn tín hiệu](docs/UE5_TRAFFIC_SIGNAL.md), [nhiên liệu và trạm xăng](docs/UE5_FUEL_AND_STATION.md).

## Tính chân thực
Mục tiêu là tái tạo địa điểm dựa trên dữ liệu, ảnh tham chiếu và quyền sử dụng được xác minh. Không tuyên bố mô phỏng chính xác 100% mọi địa phương. Bản đầu tiên sẽ là một vertical slice nhỏ, được kiểm thử và tối ưu trước khi mở rộng.
