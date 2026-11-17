# Hồ sơ nhân vật và gia đình – Save schema v3

## Mục tiêu

Lưu dữ liệu bền vững để nhân vật người chơi và gia đình có danh tính nhất quán qua các phiên chơi. Đây là data model, chưa phải nhân vật 3D hay AI hoàn chỉnh.

## Dữ liệu nhân vật người chơi

`FVNHSavedAppearance` lưu các ID preset ổn định:
- BodyTypeId
- FacePresetId
- SkinToneId
- HairStyleId và HairColorId
- OutfitId
- HeightCm

Game không lưu con trỏ mesh/material trực tiếp trong SaveGame. Khi tạo nhân vật, Blueprint/appearance resolver sẽ ánh xạ các ID này sang Skeletal Mesh, material, tóc và trang phục đã được import, kiểm duyệt và tối ưu cho mobile.

Các ID hiện tại chỉ là giá trị khởi tạo mẫu; chưa đại diện cho thư viện ngoại hình hoặc asset người Việt đã sản xuất. Cần tạo bộ tùy chỉnh đa dạng, tránh định kiến và cho phép thay đổi trong gameplay.

## Dữ liệu thành viên gia đình

`FVNHFamilyMemberSave` lưu:
- CharacterId, FamilyRoleId, DisplayNameKey
- AgeYears và Relationship (0–100)
- DailyRoutineId
- AppearancePresetId

Save mới tạo hai hồ sơ thành viên gia đình với vai trò mẹ/bố và routine ID mẫu. Tuổi và mức quan hệ hiện là giá trị khởi tạo placeholder để kiểm thử hệ thống; cần chuyển thành dữ liệu do thiết kế nhân vật quyết định trước khi phát hành.

## Migration

Save schema v1 được nâng lên v2 để bổ sung nhà và định danh bố mẹ.
Save schema v2 được nâng lên v3 để bổ sung hồ sơ ngoại hình và mảng thành viên gia đình.
Migration không tự chọn nghề, không thay tiền và không thay vị trí hành trình. Save có schema mới hơn bị từ chối thay vì ghi đè.

## Dùng trong Unreal Editor

1. Tạo DataTable hoặc Primary Data Asset cho appearance presets.
2. Tạo resolver từ preset IDs sang mesh/material/animation blueprint.
3. Tạo Blueprint nhân vật bố mẹ dựa trên CharacterId.
4. Tạo Data Asset lịch sinh hoạt theo giờ mô phỏng và ngày trong tuần.
5. Dùng FamilyMembers để khôi phục quan hệ và lịch; không spawn NPC chỉ dựa vào tên hiển thị.
6. Kiểm tra các ID chưa tồn tại và dùng fallback an toàn có thông báo log.

## Chưa được triển khai

- Character creator UI và thư viện khuôn mặt/tóc/trang phục.
- Skeletal mesh chất lượng cao, facial rig, body rig và animation.
- NPC bố mẹ trong world, dialogue, relationship gameplay và routine scheduler.
- Nhà gia đình 3D, nội thất và tương tác.
- Compile/runtime tests bằng Unreal Engine 5.8.

Không quảng bá schema này là tính năng tạo người chân thực đã hoàn thành.
