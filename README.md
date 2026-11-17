# Việt Nam – Hành Trình Bất Tận

Game mô phỏng du lịch và đời sống Việt Nam theo hướng thế giới mở, phát hành mục tiêu đầu tiên trên Android và iPhone.

## Hướng công nghệ đã chốt
- **Engine chính:** Unreal Engine 5.
- **Nền tảng đầu tiên:** Android và iOS.
- **Godot prototype:** vẫn giữ ở thư mục gốc để tham chiếu, không còn là nền tảng phát triển game chính.
- **Unreal scaffold:** nằm trong thư mục `Unreal/`.

## Trạng thái thực tế
Repository có bộ khung UE5 C++ gồm GameMode, PlayerController, nhân vật góc nhìn thứ ba, camera, hàm điều khiển cảm ứng, lưu tiến trình cục bộ, trace tương tác và actor điểm tham quan (POI). Khu vực Hồ Hoàn Kiếm hiện có actor dựng khối greybox với nền, hồ, đường, vỉa hè và khối đại diện một số địa danh. Hệ thống POI có thể tương tác và Pawn phương tiện arcade thử nghiệm đã được thêm vào mã nguồn; phương tiện hỗ trợ vào/ra, ga, lùi, phanh, đánh lái và camera bám xe. Bộ khung NPC người dân có AI tuần tra giữa các điểm, interface tương tác và sự kiện Blueprint để mở hội thoại cũng đã được thêm; NPC cần Blueprint có mesh/animation và Nav Mesh để hoạt động.

Chưa xác nhận biên dịch bằng Unreal Editor. Chưa có level `.umap` đã tạo trong Editor, nhân vật 3D hoàn chỉnh, animation, mô hình địa danh chi tiết, xe cộ, NPC, đăng nhập Google/Apple, cloud save hoặc APK/IPA. Phương tiện hiện dùng mesh hình khối và chuyển động arcade, chưa phải mô phỏng Chaos Vehicles hay xe máy hoàn chỉnh. NPC mới chỉ có logic tuần tra cơ bản; chưa có mô hình người, animation, hội thoại, hệ thống đám đông hoặc AI giao thông.

## Mở dự án Unreal
1. Cài Unreal Engine phiên bản tương thích với `EngineAssociation` trong project descriptor.
2. Mở `Unreal/VietNamHanhTrinh.uproject` trong Unreal Editor.
3. Generate project files và build C++ module.
4. Tạo map đầu tiên trong Content Browser, đặt actor `VNHHanoiPrototypeArea` vào map và cấu hình PlayerStart.
5. Cấu hình Android SDK/NDK và test trên thiết bị Android.
6. Build iOS cần máy Mac, Xcode và chứng chỉ ký ứng dụng.

## Kiến trúc và lộ trình
Xem [Kiến trúc Unreal Engine 5](docs/UE5_MOBILE_ARCHITECTURE.md), [Quy trình nội dung địa phương](docs/VIETNAM_CONTENT_PIPELINE.md), [Blockout Hồ Hoàn Kiếm](docs/UE5_HANOI_HOAN_KIEM_BLOCKOUT.md) và [POI tương tác](docs/UE5_POI_INTERACTION.md) và [phương tiện thử nghiệm](docs/UE5_VEHICLE_PROTOTYPE.md), [NPC tuần tra](docs/UE5_CIVILIAN_NPC_PATROL.md).

## Tính chân thực
Mục tiêu là tái tạo địa điểm dựa trên dữ liệu, ảnh tham chiếu và quyền sử dụng được xác minh. Không tuyên bố mô phỏng chính xác 100% mọi địa phương. Bản đầu tiên sẽ là một vertical slice nhỏ, được kiểm thử và tối ưu trước khi mở rộng.
