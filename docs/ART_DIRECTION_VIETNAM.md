# Art Direction: Việt Nam chân thực

Tài liệu này đặt tiêu chuẩn cho giai đoạn thay placeholder bằng tài sản 3D chất lượng cao. Mục tiêu là tái hiện đời sống Việt Nam có nghiên cứu, có bản sắc địa phương và chạy được trên điện thoại; không tuyên bố đạt độ chân thực tuyệt đối trước khi có tài sản và kiểm thử thực tế.

## 1. Nguyên tắc sản xuất

- Thu thập ảnh tham chiếu tại địa phương hoặc từ nguồn có giấy phép; ghi lại tỉnh/thành, thời điểm, góc chụp và quyền sử dụng.
- Dùng photogrammetry hoặc scan có sự đồng ý của chủ thể/chủ sở hữu địa điểm; làm sạch mesh, retopology, UV và LOD trước khi đưa vào game.
- Vật liệu PBR phải có albedo/base color, normal, roughness và metallic đúng vật liệu; tránh chỉ đổi màu mesh khối.
- Mỗi địa phương phải có bộ kiến trúc, biển hiệu, cây cối, mặt đường, dây điện, vỉa hè, phương tiện và âm thanh môi trường riêng.
- Tất cả nội dung thương hiệu, logo, mẫu xe và biển hiệu thương mại phải được kiểm tra quyền sử dụng trước khi phát hành thương mại.

## 2. Xe máy phổ biến

Catalog prototype hiện có 11 mẫu: Honda Wave Alpha 110, Vision, Air Blade 125, SH160i, LEAD 125, Future 125 FI, Winner X; Yamaha Sirius FI, Exciter 155 VVA, Janus và Grande.

Mỗi mẫu hoàn chỉnh cần:
- Silhouette đúng đời xe/năm sản xuất, tỷ lệ bánh, chiều dài cơ sở, yên, sàn để chân, yếm, đèn, gương, pô, phanh và cụm đồng hồ.
- Bộ phận tách riêng để đổi màu thân xe, thay gương/biển số/phụ kiện và có thể hư hỏng ở mức gameplay.
- Rig bánh trước, bánh sau, tay lái, giảm xóc và chân chống; animation lên/xuống xe và chống chân khi dừng.
- Âm thanh khởi động, garanti, tăng ga, giảm ga, phanh, còi và xi-nhan được thu/thiết kế hợp pháp.
- Tư thế người lái khác nhau giữa xe số, xe tay ga và xe côn tay; nhân vật phải đặt tay/chân đúng vị trí.

Các mesh hiện tại chỉ là placeholder phân biệt dáng xe số, tay ga và xe thể thao. Chúng không phải mô hình chính xác do nhà sản xuất cung cấp.

## 3. Nhân vật Việt Nam

Mục tiêu là nhân vật đa dạng, tự nhiên, không dùng một khuôn mặt cho toàn bộ NPC:
- Nhiều độ tuổi, vóc dáng, chiều cao, kiểu tóc, màu da tự nhiên và trang phục theo nghề/ngữ cảnh.
- Khuôn mặt có cấu trúc giải phẫu, mắt, mí, mũi, môi, tai, tóc và biểu cảm; tạo nhiều biến thể có kiểm soát thay vì nhân bản cùng một mesh.
- Nhân vật chính có thể tùy chỉnh tóc, khuôn mặt, vóc dáng, giới tính trình bày, trang phục và phụ kiện.
- NPC có skeleton humanoid, retarget animation, locomotion blend tree, idle, nói chuyện, cầm đồ, ăn uống, lái xe và tương tác gia đình.
- Dùng mocap/animation có bản quyền hoặc tự sản xuất; biểu cảm khuôn mặt cần facial rig khi ngân sách thiết bị cho phép.
- Chỉ scan khuôn mặt người thật khi có đồng ý rõ ràng và quyền sử dụng dữ liệu.

Nhân vật trong prototype hiện là mô hình low-poly ghép từ primitive để kiểm tra gameplay, chưa phải người Việt photorealistic.

## 4. Thời trang và cửa hàng

Các nhóm sản phẩm cần mở rộng:
- Đời thường: áo thun, sơ mi, polo, hoodie, áo khoác, quần jeans, quần tây, váy, đồ mặc nhà.
- Đi xe: nón bảo hiểm, áo khoác chống nắng, khẩu trang, găng tay, giày và dép.
- Truyền thống/vùng miền: áo dài, áo bà ba và trang phục lễ hội có tham chiếu đúng bối cảnh.
- Đồng phục nghề: tài xế, hướng dẫn viên, đầu bếp, nhân viên cửa hàng.

Mỗi món đồ cần mesh/rig phù hợp cơ thể, cloth clipping test, texture vải và lựa chọn màu/kích cỡ. Hệ thống tủ đồ phải lưu món đã mua và trang phục đang mặc.

## 5. Ẩm thực và đặc sản

Mỗi món phải gắn với địa phương, mô tả nguyên liệu, cách phục vụ, giá trong game và bối cảnh bán hàng. Catalog nên phát triển theo vùng:
- Bắc: phở, bún chả, bánh cuốn, chả cá, cốm và đặc sản theo tỉnh.
- Trung: bún bò Huế, mì Quảng, cao lầu, bánh bèo, bánh xèo miền Trung và đặc sản địa phương.
- Nam: cơm tấm, hủ tiếu, bánh xèo Nam Bộ, gỏi cuốn, bánh pía, nem chua và trái cây theo mùa.

Cần phân biệt món ăn theo địa phương, không gắn sai nguồn gốc. Mô hình món ăn cần texture/normal, hơi nóng khi phù hợp, animation phục vụ và âm thanh quán ăn. Giá hiện tại trong game là giá cân bằng gameplay, không phải giá thị trường.

## 6. Chuẩn hiệu năng Android/iPhone

- Tạo LOD cho nhân vật, xe và công trình; dùng occlusion culling và distance culling.
- Ưu tiên texture atlas, mipmaps, nén ASTC/ETC2 và vật liệu dùng chung.
- NPC ở xa dùng animation đơn giản; chỉ bật facial animation gần camera.
- Tách chất lượng Low/Medium/High theo RAM, GPU và nhiệt độ thiết bị.
- Kiểm thử trên điện thoại Android cấu hình thấp trước khi tăng mật độ NPC/xe.
- Không dùng ảnh hoặc mô hình không rõ giấy phép; lưu nguồn và giấy phép trong metadata asset.

## 7. Điều kiện chấp nhận trước khi gọi là chân thực

1. Đúng tỷ lệ và silhouette khi so với bộ ảnh tham chiếu được duyệt.
2. Chất liệu, ánh sáng, bóng đổ và phản xạ hợp lý trong nhiều điều kiện thời tiết.
3. Animation không xuyên mesh, không trượt chân và tư thế lái xe đúng.
4. Người địa phương/nhóm QA kiểm tra biển hiệu, kiến trúc, món ăn, trang phục và cách phát âm.
5. Chạy ổn định trên thiết bị mục tiêu; không đánh đổi gameplay chỉ để tăng polygon.
6. Có xác nhận quyền sử dụng cho mô hình, ảnh, âm thanh, thương hiệu và dữ liệu scan.

## Trạng thái hiện tại

Đã có catalog mẫu, shop UI, lưu quyền sở hữu, trang phục đang mặc, độ no và mô hình nhân vật/xe procedural để kiểm thử luồng chơi. Chưa có bộ scan, model thương mại được cấp phép, mocap, facial rig hay môi trường photorealistic.
