# Kiến trúc game – Việt Nam: Hành Trình Bất Tận

## 1. Quyết định nền tảng

- Engine chính: Unreal Engine 5, C++ cho hệ thống nền và Blueprint cho nội dung/gameplay có thể cấu hình.
- Nền tảng phát hành đầu tiên: Android và iOS.
- PC là nền tảng phát triển/kiểm thử bổ sung, không phải mục tiêu phát hành đầu tiên.
- Godot ở thư mục gốc được giữ làm prototype tham chiếu điều khiển và UI; không trộn mã Godot vào runtime Unreal.
- Ưu tiên Mobile Forward Renderer, baked/static lighting, LOD/HLOD, texture streaming và scalability theo thiết bị.
- Không phụ thuộc Nanite hoặc Lumen để game chạy được trên điện thoại. Có thể nghiên cứu nhánh PC chất lượng cao riêng sau này.

## 2. Sơ đồ module

```text
VietNamHanhTrinh
├── Core
│   ├── GameInstance / GameMode / PlayerController
│   ├── GameFlow (FirstLaunch, Continue, NewGame)
│   ├── SaveSystem (local save, schema migration)
│   ├── Account (Google / Apple sign-in adapter)
│   └── CloudSave (provider-neutral API)
├── World
│   ├── WorldPartition / region streaming
│   ├── RegionDefinition (province, district, ward, POI)
│   ├── RoadGraph / navigation
│   ├── Terrain, water, vegetation, weather
│   └── Landmark validation metadata
├── Player
│   ├── Character, camera, touch controls
│   ├── Interaction, locomotion, animation
│   └── Accessibility and control settings
├── Vehicles
│   ├── Motorbike, car, bus, taxi
│   ├── Vehicle physics and traffic rules
│   └── Fuel, parking, repair
├── NPC
│   ├── Crowd/traffic population tiers
│   ├── Schedules, dialogue, reactions
│   └── Performance-aware spawn/despawn
├── Gameplay
│   ├── Missions and activities
│   ├── Jobs, economy, inventory
│   ├── Shops, food, tourism, accommodation
│   └── Progression and achievements
├── Online
│   ├── Identity adapters
│   ├── Cloud save conflict resolution
│   └── Analytics/telemetry (opt-in, privacy-aware)
└── UI
    ├── Start, login, continue, settings
    ├── HUD, map, inventory, mission journal
    └── Localization (Vietnamese first)
```

## 3. Quy tắc phụ thuộc

- Core không phụ thuộc vào map/địa danh cụ thể.
- World cung cấp interface vị trí, vùng, POI và đường đi; Gameplay tiêu thụ các interface này.
- Player và Vehicles dùng chung hệ thống input/action mapping.
- UI chỉ gọi service/interface; không trực tiếp sửa dữ liệu lưu.
- SaveSystem lưu ID ổn định, không lưu con trỏ UObject hoặc đường dẫn asset tạm.
- Account xác thực danh tính; CloudSave đồng bộ dữ liệu. Hai chức năng không được gộp thành một.
- Dữ liệu địa phương và asset 3D tách riêng khỏi logic gameplay để cập nhật theo gói vùng.

## 4. Luồng khởi động và tài khoản

1. Lần đầu mở: Bắt đầu, Đăng nhập Google, Đăng nhập Apple (nếu bật).
2. Người chơi có thể bắt đầu khách và chơi offline; không bắt buộc đăng nhập.
3. Khi có local save: hiển thị Tiếp tục và Chơi mới.
4. Đăng nhập tài khoản: liên kết guest profile theo quy trình xác nhận, tránh ghi đè save.
5. Cloud save: tải metadata trước, so sánh revision/timestamp, xử lý xung đột rõ ràng rồi mới áp dụng.
6. Nếu offline: tiếp tục local save, đưa thay đổi vào hàng đợi đồng bộ.
7. Không bao giờ lưu access token hoặc mật khẩu trong SaveGame.

## 5. Lưu tiến trình

Dùng save schema có phiên bản và ID ổn định:
- Player profile ID và save schema version.
- Level, tiền, vật phẩm (item IDs), nhiệm vụ đã hoàn thành.
- Region/POI gần nhất và checkpoint hợp lệ.
- Thiết lập điều khiển, âm thanh, đồ họa và ngôn ngữ.
- Metadata đồng bộ: revision, updated-at, device-generated operation ID.

Dữ liệu nhạy cảm xác thực nằm trong kho bảo mật của nền tảng, không nằm trong save file. Cloud API và backend chưa được chọn; không hard-code nhà cung cấp.

## 6. Kiến trúc thế giới thực

- Chia bản đồ thành region/streaming cells; tải vùng lân cận, giải phóng vùng xa.
- RoadGraph dùng ID nút/cạnh ổn định; dữ liệu đường phải được làm sạch và kiểm tra trước khi đưa vào gameplay.
- POI có tọa độ, loại địa điểm, nguồn tham chiếu, ngày xác minh, giấy phép và mức độ tin cậy.
- Mesh/texture/âm thanh phải có provenance và quyền sử dụng được ghi nhận.
- Ảnh vệ tinh/bản đồ không tự động trở thành texture game; phải kiểm tra giấy phép và điều khoản nguồn.
- Landmark quan trọng cần đối chiếu ảnh tại chỗ, kích thước, silhouette, vật liệu và bố cục.
- Không quảng bá khu vực prototype là bản sao chính xác của địa điểm thật.

## 7. Mục tiêu hiệu năng mobile

Đây là mục tiêu kiểm thử ban đầu, không phải cam kết hiệu năng trên mọi máy:
- Thiết bị thấp: 30 FPS mục tiêu, mật độ NPC/traffic thấp, bóng và hiệu ứng giảm.
- Thiết bị trung: 30–45 FPS mục tiêu, LOD và streaming cân bằng.
- Thiết bị cao: 45–60 FPS tùy nhiệt độ và giới hạn điện năng.
- Dynamic resolution/scalability theo GPU, RAM và thermal state.
- Giới hạn draw calls, material slots, shader permutations và kích thước texture.
- Dùng texture ASTC khi phần cứng hỗ trợ, fallback phù hợp khi cần.
- Không giữ toàn bộ tỉnh/thành trong RAM; streaming theo vùng.
- Profiling trên thiết bị thật bằng Unreal Insights, Stat GPU, memory/thermal tests.

## 8. Quy trình nội dung

1. Chọn một vertical slice nhỏ: khu vực quanh Hồ Hoàn Kiếm, Hà Nội.
2. Khóa ranh giới, tọa độ, danh sách POI và tuyến đi bộ.
3. Thu thập nguồn dữ liệu có giấy phép; ghi nguồn và ngày xác minh.
4. Dựng blockout địa hình/đường/landmark.
5. Tạo art pass, vật liệu, ánh sáng và âm thanh.
6. Thêm nhân vật, tương tác và nhiệm vụ tham quan ngắn.
7. Kiểm thử trên Android/iPhone; tối ưu rồi mới mở rộng vùng.
8. Chỉ sau khi vertical slice đạt tiêu chí mới mở rộng phố cổ và khu vực khác.

## 9. Vertical slice đầu tiên

Phạm vi có thể hoàn thành và kiểm chứng:
- Một vùng đi bộ nhỏ, không phải toàn bộ Hà Nội.
- Một nhân vật người chơi, camera và điều khiển cảm ứng.
- 3–5 POI được xác minh, một tuyến tham quan.
- Một nhiệm vụ, một vật phẩm, một điểm lưu.
- Local save/load và giao diện Bắt đầu/Tiếp tục.
- Android build thử nghiệm trước; iOS build sau khi cấu hình máy Mac/Xcode và ký ứng dụng.

Tiêu chí nghiệm thu:
- Khởi động, di chuyển, tương tác và lưu/tải hoạt động ổn định.
- Không crash khi chuyển qua lại giữa menu và gameplay.
- FPS, RAM, nhiệt độ và dung lượng được đo trên thiết bị thật.
- Mọi POI hiển thị đúng trạng thái nguồn/độ tin cậy.
- Không dùng asset không rõ giấy phép.

## 10. Các giai đoạn

| Giai đoạn | Kết quả |
|---|---|
| A – Foundation | C++ module, game flow, input, save schema, cấu hình mobile |
| B – Vertical slice | Một khu vực mẫu, nhân vật, POI, nhiệm vụ, local save |
| C – World systems | Region streaming, road graph, phương tiện, traffic |
| D – Living world | NPC schedules, jobs, economy, shops, food, tourism |
| E – Online | Google/Apple identity, cloud save, conflict handling |
| F – Scale & release | Nhiều vùng, tối ưu thiết bị, QA, store packaging |

## 11. Rủi ro và giới hạn

- Dựng thế giới Việt Nam chân thực cần thời gian, khảo sát, dữ liệu có giấy phép và đội ngũ art/technical art.
- iOS packaging/signing cần macOS và Xcode; Windows CI không thể thay thế toàn bộ bước này.
- Google/Apple sign-in cần OAuth configuration, bundle/package IDs, backend validation và chính sách quyền riêng tư.
- Chưa có backend cloud save; chưa tuyên bố đồng bộ tài khoản đã hoạt động.
- Khung mã nguồn hiện tại chưa được compile bằng Unreal Editor; cần xác minh trong đúng phiên bản engine trước khi xem là buildable.
