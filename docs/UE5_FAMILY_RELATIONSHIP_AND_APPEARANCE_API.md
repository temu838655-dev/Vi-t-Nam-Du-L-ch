# API quan hệ gia đình và ngoại hình người chơi

Tài liệu này mô tả hai API C++/Blueprint bổ sung cho SaveGame schema v3. Đây là lớp lưu dữ liệu; nó chưa tự tạo giao diện tạo nhân vật, mesh 3D, hội thoại hoặc hoạt ảnh.

## 1. Cập nhật quan hệ gia đình

`UVNHSaveSubsystem::UpdateFamilyRelationship(CharacterId, Delta)`

- Tìm thành viên theo `CharacterId` trong `FamilyMembers`.
- Cộng `Delta` vào điểm quan hệ hiện tại.
- Giới hạn kết quả trong khoảng 0–100.
- Lưu ngay bằng `SaveProgress`.
- Trả về false nếu không có save, ID rỗng, Delta bằng 0 hoặc không tìm thấy thành viên.

Ví dụ Blueprint: khi người chơi hoàn thành một việc giúp mẹ, gọi API với ID `FAMILY_MOTHER` và Delta `+5`. Khi có xung đột, gameplay có thể gửi Delta âm. Cần thiết kế hành động, hội thoại và cân bằng điểm ở lớp gameplay; API không tự quyết định sự kiện nào làm tăng/giảm quan hệ.

## 2. Lưu ngoại hình người chơi

`UVNHSaveSubsystem::SetPlayerAppearance(Appearance)`

Yêu cầu các ID preset sau không rỗng: BodyTypeId, FacePresetId, SkinToneId, HairStyleId, HairColorId và OutfitId. Chiều cao phải là số hữu hạn trong khoảng 120–220 cm. Nếu dữ liệu hợp lệ, struct được ghi vào SaveGame.

Các ID là khóa dữ liệu ổn định, không phải asset 3D. Character Appearance Resolver cần ánh xạ chúng sang Skeletal Mesh, morph target, material và outfit thực tế. Khi preset không tồn tại trong catalog, lớp resolver nên dùng preset dự phòng và ghi log; không được làm hỏng save.

## 3. Ví dụ sử dụng

- Bố/mẹ có thể thay đổi quan hệ dựa trên lựa chọn và hành vi người chơi.
- Người chơi chỉnh tóc, màu tóc, trang phục hoặc chiều cao trong màn hình tạo nhân vật rồi gọi API lưu.
- Mỗi lần lưu đều tăng LocalRevision theo cơ chế SaveProgress hiện tại.

## 4. Giới hạn hiện tại

Chưa có UI tạo nhân vật, catalog preset hoàn chỉnh, asset nhân vật chất lượng sản xuất, hệ thống hội thoại, lịch sinh hoạt gia đình hoặc kiểm thử trong Unreal Editor 5.8. API này chỉ hoàn thiện phần lưu trữ và là nền tảng cho các hệ thống đó.
