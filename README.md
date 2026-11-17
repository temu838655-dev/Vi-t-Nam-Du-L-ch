# Việt Nam – Hành Trình Bất Tận

Game mô phỏng du lịch và đời sống Việt Nam theo hướng thế giới mở. Engine duy nhất của dự án là **Unreal Engine 5.8**; nền tảng ưu tiên là **Android và iPhone (iOS)**.

## Kiến trúc công nghệ
- **Game engine:** Unreal Engine 5.8.
- **Ngôn ngữ gameplay nền tảng:** C++ và Blueprint trong Unreal Editor.
- **Nền tảng mục tiêu:** Android ARM64 và iOS.
- **Project:** [Unreal/VietNamHanhTrinh.uproject](Unreal/VietNamHanhTrinh.uproject).
- Mã nguồn engine cũ và workflow build của engine cũ đã được loại khỏi nhánh main. Không duy trì song song một prototype engine khác.

## Những hệ thống UE5 đã có trong mã nguồn
- GameMode tự dựng blockout Hồ Hoàn Kiếm và PlayerStart dự phòng trên map trống; PlayerController hỗ trợ tạo HUD UMG cấu hình từ Blueprint.
- Cầu nối UMG cho joystick, vuốt camera, chạy, nhảy, tương tác và điều khiển xe.
- SaveGame và subsystem lưu tiến trình cục bộ.
- Actor khu vực blockout Hồ Hoàn Kiếm, POI có thể tương tác.
- Pawn ô tô/xe máy thử nghiệm, điều khiển arcade, vào/ra phương tiện.
- NPC dân cư với AI tuần tra cơ bản.
- AI xe chạy theo spline và actor đèn giao thông prototype.
- Hệ thống nhiên liệu, trạm xăng và ví tiền cục bộ.

## Trạng thái build trung thực
Mã nguồn UE5 đã được tổ chức nhưng **chưa xác nhận compile bằng Unreal Editor và chưa có APK/IPA UE5 đã kiểm thử**. Repository chưa có map hoàn chỉnh được tạo trong Editor, asset nhân vật/xe/địa danh chất lượng sản xuất, animation và giao diện UMG hoàn chỉnh. Các hệ thống xe, NPC, giao thông, nhiên liệu hiện là nền tảng prototype C++, chưa phải gameplay hoàn thiện.

Không lấy bất kỳ APK prototype engine cũ nào làm bản build của dự án UE5.

## Mở dự án
1. Cài Unreal Engine 5.8 và các thành phần Android cần thiết.
2. Mở Unreal/VietNamHanhTrinh.uproject.
3. Generate project files và biên dịch module C++ trong môi trường Unreal.
4. Tạo map trong Unreal Editor, đặt PlayerStart và các actor prototype.
5. Kiểm tra trên thiết bị Android; cấu hình ký ứng dụng trước khi phát hành.
6. Build iOS cần macOS, Xcode và provisioning/signing hợp lệ.

## Tài liệu
- [Kiến trúc UE5 mobile](docs/UE5_MOBILE_ARCHITECTURE.md)
- [Thiết lập HUD UMG cảm ứng](docs/UE5_MOBILE_UMG_SETUP.md)
- [Quy trình nội dung địa phương](docs/VIETNAM_CONTENT_PIPELINE.md)
- [Blockout Hồ Hoàn Kiếm](docs/UE5_HANOI_HOAN_KIEM_BLOCKOUT.md)
- [POI tương tác](docs/UE5_POI_INTERACTION.md)
- [Phương tiện thử nghiệm](docs/UE5_VEHICLE_PROTOTYPE.md)
- [NPC tuần tra](docs/UE5_CIVILIAN_NPC_PATROL.md)
- [AI giao thông](docs/UE5_TRAFFIC_AI_ROUTE.md)
- [Xe máy thử nghiệm](docs/UE5_MOTORBIKE_PROTOTYPE.md)
- [Đèn tín hiệu](docs/UE5_TRAFFIC_SIGNAL.md)
- [Nhiên liệu và trạm xăng](docs/UE5_FUEL_AND_STATION.md)
- [Trạng thái build](docs/BUILD_PREVIEW_STATUS.md)

## Mục tiêu chất lượng
Tái tạo địa điểm Việt Nam dựa trên dữ liệu địa lý, ảnh tham chiếu và quyền sử dụng được xác minh. Phát triển theo từng khu vực nhỏ (vertical slice), ưu tiên độ ổn định và hiệu năng di động trước khi mở rộng bản đồ. Không tuyên bố độ chính xác 100% hoặc tương đương GTA 6 khi chưa có dữ liệu, asset và kiểm thử chứng minh.