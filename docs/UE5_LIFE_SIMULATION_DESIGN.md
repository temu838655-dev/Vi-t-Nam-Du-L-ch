# Thiết kế mô phỏng cuộc sống Việt Nam

## Định hướng chính

Đây là game **mô phỏng cuộc sống tự do kết hợp du lịch thế giới mở**, không phải game chỉ đi tham quan hoặc chạy nhiệm vụ theo tuyến. Người chơi tạo và điều khiển một nhân vật có gia đình, nhà ở, công việc và tài chính. Người chơi tự chọn nhịp sống: đi làm, ở nhà, thăm bố mẹ, mua sắm, lái xe, gặp gỡ bạn bè hoặc tự lên đường du lịch khắp Việt Nam.

Không ép người chơi phải làm nhiệm vụ du lịch. Không dùng checkpoint ở điểm tham quan làm nơi hồi sinh mặc định.

## Vòng lặp cuộc sống

1. **Bắt đầu cuộc sống:** tạo nhân vật, chọn ngoại hình và thông tin cơ bản; bắt đầu tại nhà gia đình.
2. **Gia đình:** nhân vật có bố và mẹ là các NPC có danh tính, lịch sinh hoạt và khả năng tương tác. Có thể trò chuyện, ăn cơm, nhận lời nhắc hoặc hỗ trợ gia đình.
3. **Nhà ở:** có một căn nhà gia đình làm nơi ở ban đầu. Nhà có vị trí cố định trên bản đồ, điểm vào/ra, phòng và đồ vật có thể mở rộng về sau. Người chơi có thể về nhà bất cứ lúc nào nếu đường đi cho phép.
4. **Nghề nghiệp tự chọn:** người chơi xem danh sách nghề, yêu cầu, nơi làm và thu nhập; tự đăng ký/chọn công việc. Không tự gán nghề bắt buộc. `SelectedJobId = NAME_None` nghĩa là chưa chọn nghề.
5. **Làm việc và thu nhập:** đến đúng nơi làm việc, thực hiện ca làm/hoạt động nghề, nhận lương; dùng tiền cho ăn uống, thuê/mua nhà, phương tiện, nhiên liệu và du lịch.
6. **Du lịch tự túc:** người chơi tự chọn điểm đến, phương tiện, lộ trình, thời gian lưu trú và ngân sách. Có thể đi một mình hoặc cùng NPC khi tính năng đồng hành được phát triển.
7. **Thế giới tiếp diễn:** NPC và các hoạt động có lịch theo thời gian trong game; lựa chọn của người chơi ảnh hưởng đến tiền, công việc, quan hệ và tiến trình.

## Nguyên tắc lưu dữ liệu

Dữ liệu nhà và gia đình là dữ liệu đời sống lâu dài, tách biệt với vị trí người chơi đang đi du lịch.

- `HomeRegionId`, `HomeLocationId`: nơi ở cố định của nhân vật.
- `MotherCharacterId`, `FatherCharacterId`: định danh bố mẹ/NPC gia đình.
- `SelectedJobId`, `WorkplaceId`, `MonthlySalary`, `CompletedWorkShifts`: nghề nghiệp và tiến trình làm việc.
- `CurrentRegionId`: khu vực người chơi đang ở hiện tại.
- `LastCheckpointId`: mốc lưu vị trí gần nhất, không có nghĩa là phải hồi sinh tại điểm du lịch.

Save schema đã tăng lên phiên bản 2 để bổ sung các trường này. Các ID chỉ là dữ liệu định danh; bản đồ nhà, NPC bố mẹ, nghề, hoạt ảnh, lịch sinh hoạt và giao diện tương tác vẫn cần được tạo trong Unreal Editor/C++.

## Quy tắc tiếp tục game và vị trí xuất hiện

- Khi chọn **Tiếp tục**, tải vị trí đã lưu gần nhất nếu vị trí đó hợp lệ.
- Khi **Chơi mới**, bắt đầu tại nhà gia đình, không xuất hiện ngẫu nhiên ở một điểm tham quan.
- Nếu vị trí đang lưu không còn hợp lệ (ví dụ khu vực chưa được tải hoặc nội dung bị thiếu), dùng nhà gia đình làm điểm an toàn dự phòng.
- Chỉ dùng checkpoint du lịch như điểm tiếp tục hành trình, không biến nó thành cơ chế hồi sinh kiểu game hành động.
- Không tự đưa nhân vật về nhà mỗi lần thoát game; việc trở về nhà là lựa chọn gameplay, trừ trường hợp dữ liệu vị trí bị lỗi.

## Giai đoạn triển khai

### Giai đoạn 1 — Nền tảng cuộc sống
- Tạo nhân vật và lưu hồ sơ.
- Dựng căn nhà gia đình đầu tiên trong khu vực Hà Nội.
- Tạo NPC bố và mẹ, hội thoại tương tác cơ bản.
- Tạo menu nghề nghiệp và ít nhất một nghề thử nghiệm.
- Lưu nhà, gia đình, nghề, tiền và vị trí.

### Giai đoạn 2 — Sinh hoạt và kinh tế
- Lịch ngày/đêm, giờ làm và ngày nghỉ.
- Ăn uống, mua sắm, chi phí sinh hoạt.
- Lương theo ca/ngày và quản lý tiền.
- Tương tác trong nhà và quan hệ gia đình.

### Giai đoạn 3 — Du lịch tự do
- Bản đồ vùng/địa điểm, phương tiện và hành trình.
- Khách sạn, nhà nghỉ, trạm xăng, cửa hàng.
- Lưu hành trình và tiếp tục đúng vị trí khi mở game.

## Trạng thái kỹ thuật trung thực

Hiện SaveGame C++ đã có các trường dữ liệu ban đầu cho nhà, bố mẹ và nghề nghiệp. Đây **chưa phải** hệ thống gia đình/công việc hoàn chỉnh: chưa có NPC bố mẹ được dựng trong map, nhà có thể đi vào, danh sách nghề, lịch làm, bảng lương hoặc giao diện chọn nghề. Các phần đó là các hạng mục triển khai tiếp theo. Chưa compile hoặc kiểm thử runtime bằng Unreal Engine 5.8.
