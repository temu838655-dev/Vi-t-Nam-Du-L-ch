# Việt Nam – Hành Trình Bất Tận

Game mô phỏng du lịch và đời sống Việt Nam theo hướng thế giới mở, phát hành mục tiêu đầu tiên trên Android và iPhone.

## Hướng công nghệ đã chốt
- **Engine chính:** Unreal Engine 5.
- **Nền tảng đầu tiên:** Android và iOS.
- **Godot prototype:** vẫn giữ ở thư mục gốc để tham chiếu, không còn là nền tảng phát triển game chính.
- **Unreal scaffold:** nằm trong thư mục `Unreal/`.

## Trạng thái thực tế
Repository hiện có prototype Godot và bộ khung Unreal Engine 5 gồm project descriptor, C++ module, GameMode, PlayerController, cấu hình mobile và cấu trúc save data ban đầu. Khung Unreal chưa được compile bằng Unreal Editor và chưa có bản game chơi được, map, nhân vật 3D, phương tiện, NPC hoặc asset địa phương.

## Mở dự án Unreal
1. Cài Unreal Engine 5.8 (baseline của scaffold) hoặc phiên bản tương thích.
2. Mở `Unreal/VietNamHanhTrinh.uproject` trong Unreal Editor.
3. Generate project files và build C++ module.
4. Tạo map đầu tiên trong Content Browser, đặt map đó làm startup map.
5. Cấu hình Android SDK/NDK và test trên thiết bị Android.
6. Build iOS cần máy Mac, Xcode và chứng chỉ ký ứng dụng.

## Kiến trúc và lộ trình
Xem [Kiến trúc Unreal Engine 5](docs/UE5_MOBILE_ARCHITECTURE.md) và [Quy trình nội dung địa phương](docs/VIETNAM_CONTENT_PIPELINE.md).

## Tính chân thực
Mục tiêu là tái tạo địa điểm dựa trên dữ liệu, ảnh tham chiếu và quyền sử dụng được xác minh. Không tuyên bố mô phỏng chính xác 100% mọi địa phương. Bản đầu tiên sẽ là một vertical slice nhỏ, được kiểm thử và tối ưu trước khi mở rộng.
