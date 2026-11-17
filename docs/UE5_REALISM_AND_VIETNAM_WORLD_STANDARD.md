# Tiêu chuẩn tái hiện chân thực Việt Nam trong UE5

## 1. Mục tiêu và nguyên tắc

Mục tiêu là xây dựng một thế giới mô phỏng cuộc sống tại Việt Nam có độ tin cậy hình ảnh, không gian và hành vi cao. Không tuyên bố "giống thật 100%" khi chưa có dữ liệu đo đạc, nguồn tham chiếu hợp pháp và kiểm thử đối chiếu.

Mỗi nội dung phải được phân loại rõ:
- **Verified**: có dữ liệu/ảnh tham chiếu đáng tin cậy, đã đối chiếu và được duyệt.
- **Reference-built**: dựng từ tư liệu tham khảo nhưng chưa khảo sát/đo kiểm đầy đủ.
- **Fictionalized**: nội dung hư cấu hoặc đã thay đổi để phục vụ gameplay.
- **Greybox**: khối hình tạm, tuyệt đối không quảng bá là cảnh hoàn thiện.

Không tự ý biến một địa điểm hư cấu thành bản sao của địa danh có thật.

## 2. Con người và nhân vật

### Hình thể và nhận diện
- Xây dựng bộ nhân vật đa dạng về tuổi, chiều cao, vóc dáng, kiểu tóc, trang phục và phụ kiện; tránh một mẫu người lặp lại cho toàn bộ dân cư.
- Tạo nhân vật chính có thể tùy chỉnh ngoại hình ở mức phù hợp ngân sách thiết bị.
- Gương mặt cần có cấu trúc giải phẫu hợp lý, biểu cảm, ánh mắt, chuyển động môi và trạng thái cảm xúc.
- Nhân vật bố mẹ phải có ngoại hình, tuổi tác, giọng nói, thói quen và lịch sinh hoạt nhất quán với hồ sơ nhân vật.

### Chuyển động và tương tác
- Dùng skeleton/retargeting có kiểm soát; animation locomotion phải chuyển mượt giữa đứng, đi, chạy, quay đầu, ngồi, lên xe và xuống xe.
- Tạo animation riêng hoặc biến thể cho hoạt động đời thường: ăn uống, mua hàng, làm việc, chào hỏi, trò chuyện, dùng điện thoại và sinh hoạt gia đình.
- Dùng IK cho bàn chân, bàn tay và tương tác với đồ vật; tránh bàn chân trượt và tay xuyên vật thể.
- Biểu cảm/đối thoại phải đồng bộ ở mức phù hợp; không để NPC chỉ đứng bất động như tượng.
- AI cần có lịch sinh hoạt, mục tiêu, phản ứng với người chơi và hành vi theo bối cảnh; mật độ giảm theo khoảng cách để giữ hiệu năng.

### Trang phục và văn hóa
- Trang phục cần đúng bối cảnh vùng miền, độ tuổi, nghề nghiệp và thời tiết; không mặc định mọi người ở Việt Nam đều mặc một kiểu.
- Biển hiệu, đồng phục, vật dụng và hành vi phải được rà soát để tránh sai lệch văn hóa hoặc định kiến.
- Giọng nói/âm thanh địa phương chỉ triển khai khi có người thu âm hoặc nguồn được cấp quyền; không gán giọng vùng miền tùy tiện.

## 3. Địa phương và kiến trúc

Mỗi khu vực cần một hồ sơ địa phương (Region Dossier):
- Ranh giới khu vực và hệ tọa độ/nguồn dữ liệu.
- Danh sách đường, nút giao, ngõ, vỉa hè, công trình và POI.
- Ảnh tham chiếu có ngày chụp, góc chụp và quyền sử dụng.
- Kích thước/ước lượng tỷ lệ cho landmark quan trọng.
- Vật liệu bề mặt, màu sắc, cây xanh, hệ thống chiếu sáng và âm thanh môi trường.
- Biến thể theo mùa, thời tiết, giờ trong ngày khi có dữ liệu.

### Quy trình landmark
1. Chọn landmark và xác định tọa độ.
2. Thu thập nhiều góc ảnh/tư liệu hợp pháp.
3. Đo hoặc ước lượng kích thước, tỷ lệ và silhouette.
4. Dựng blockout đúng vị trí trước khi làm chi tiết.
5. Đối chiếu silhouette, mặt đứng, mái, cửa, vật liệu và bối cảnh xung quanh.
6. Chạy kiểm tra tại nhiều khoảng cách và thời điểm ánh sáng.
7. Gắn trạng thái Verified/Reference-built/Greybox cùng người duyệt và ngày cập nhật.

Không lấy ảnh bản đồ/vệ tinh làm texture trực tiếp nếu chưa kiểm tra giấy phép và điều khoản. Dữ liệu bản đồ, ảnh, mô hình photogrammetry và scan hiện trường đều phải có provenance.

## 4. Đường phố và đời sống Việt Nam

- Mạng đường phải khớp logic không gian: chiều rộng, làn, nút giao, ngõ, vỉa hè, lối sang đường và kết nối khu dân cư.
- Biển báo, vạch kẻ, đèn tín hiệu, hướng lưu thông và quy tắc giao thông phải được rà soát theo bối cảnh Việt Nam.
- Phương tiện cần đa dạng và đúng bối cảnh: xe máy, xe đạp, ô tô, taxi, xe buýt, xe tải và phương tiện dịch vụ.
- Mật độ xe/người thay đổi theo khu vực và thời gian; không dùng một mẫu giao thông dày đặc giống nhau ở mọi nơi.
- Cửa hàng, chợ, quán ăn, nhà ở, trường học, cơ sở y tế và không gian công cộng phải có hoạt động đời thường phù hợp.
- Âm thanh nền theo địa điểm: tiếng xe, người nói chuyện, loa thông báo, chim, mưa và hoạt động kinh doanh; tránh lặp một vòng âm thanh ngắn.

## 5. Độ chân thực hình ảnh

- Dùng PBR materials với roughness/normal/metallic hợp lý; tránh bề mặt bóng nhựa không đúng vật liệu.
- Ưu tiên silhouette và tỷ lệ đúng trước chi tiết nhỏ.
- Tạo LOD/Nanite chỉ khi phù hợp nền tảng; mục tiêu Android/iOS không được phụ thuộc vào tính năng không được thiết bị hỗ trợ.
- Dùng baked/static lighting và giải pháp ánh sáng mobile phù hợp; đánh giá riêng bóng, phản xạ, sương mù và hậu kỳ.
- Tạo biến thể vật liệu có kiểm soát cho tường cũ, bê tông, nhựa đường, mái tôn, kính, gỗ và mặt nước.
- Tránh lặp texture, cây, xe, người và biển hiệu dễ nhận ra.
- Thời tiết và thời gian trong ngày phải tác động nhất quán lên ánh sáng, bề mặt và hoạt động NPC.

## 6. Quy chuẩn kỹ thuật cho Android/iPhone

Chất lượng phải chia theo scalability tiers, không ép mọi điện thoại chạy cấu hình tối đa:
- **Low**: mesh/texture LOD mạnh, ít NPC/xe đồng thời, bóng đơn giản, hiệu ứng tối thiểu.
- **Mid**: tăng khoảng nhìn, mật độ và chất lượng vật liệu có giới hạn.
- **High**: tăng độ phân giải texture, mật độ và hiệu ứng nếu nhiệt độ/GPU cho phép.

Bắt buộc đo trên thiết bị thật:
- FPS và frame-time percentile.
- RAM/VRAM, kích thước gói tải và thời gian mở vùng.
- Nhiệt độ, throttling và mức tiêu thụ pin trong phiên chơi dài.
- Draw calls, shader cost, overdraw, texture memory và thời gian streaming.
- Crash rate và thời gian tải sau nhiều lần di chuyển giữa các vùng.

Không công bố mục tiêu FPS là kết quả đã đạt nếu chưa đo trên thiết bị thật. Không giữ cả Việt Nam trong bộ nhớ; dùng World Partition/streaming và gói nội dung theo vùng.

## 7. Pipeline sản xuất asset

Mỗi asset cần metadata:
- Asset ID ổn định, loại asset, vùng sử dụng.
- Nguồn tạo: tự dựng, thuê, scan hoặc nguồn được cấp phép.
- Chủ sở hữu/quyền sử dụng, giấy phép và giới hạn phân phối.
- Độ phân giải, polygon/LOD, collision, skeleton và kích thước bộ nhớ.
- Trạng thái kiểm duyệt hình ảnh/văn hóa và ngày cập nhật.

Quy trình:
1. Reference collection và xác minh quyền.
2. Blockout và duyệt tỷ lệ.
3. High/low poly hoặc tạo mesh tối ưu.
4. UV, bake, texture/PBR.
5. Collision, LOD, lightmap và import UE.
6. Tích hợp vào level/data layer.
7. Kiểm thử hình ảnh, va chạm, hiệu năng và tính nhất quán.
8. Phê duyệt trước khi gắn nhãn Verified.

## 8. Thang nghiệm thu cho từng khu vực

| Hạng mục | Kiểm tra |
|---|---|
| Địa lý | Vị trí tương đối, hướng đường, kết nối và cao độ |
| Landmark | Silhouette, tỷ lệ, mặt đứng và vật liệu |
| Đường phố | Mặt đường, vỉa hè, biển báo, vạch kẻ và giao thông |
| Con người | Hình thể, trang phục, animation, tương tác và lịch sinh hoạt |
| Đời sống | Cửa hàng, nhà ở, âm thanh và hoạt động theo thời gian |
| Mobile | FPS, RAM, nhiệt, pin, tải vùng và crash |
| Quyền sử dụng | Có nguồn, giấy phép và hồ sơ asset |

Một khu vực chỉ được nâng từ Reference-built lên Verified khi các hạng mục bắt buộc được kiểm tra và có người duyệt. Thiếu dữ liệu phải ghi rõ, không tự điền bằng phỏng đoán.

## 9. Lộ trình triển khai

1. **Hồ Hoàn Kiếm – Hà Nội**: hoàn thiện một vertical slice nhỏ, lấy độ chính xác làm chuẩn; không mở rộng diện tích trước khi đạt chất lượng.
2. **Phố cổ Hà Nội**: bổ sung ngõ, cửa hàng, giao thông, cư dân và nhịp sống.
3. **Mở rộng theo vùng**: mỗi tỉnh/thành là gói nội dung có hồ sơ dữ liệu, kiểm duyệt và QA riêng.
4. **Đời sống liên vùng**: nghề nghiệp, gia đình, kinh tế, giao thông và du lịch phải kết nối nhất quán giữa các vùng.

## 10. Trạng thái hiện tại

Tài liệu này là tiêu chuẩn sản xuất, không phải bằng chứng rằng asset đã được tạo. Repository hiện mới có blockout thử nghiệm Hồ Hoàn Kiếm và các hệ thống gameplay prototype được mô tả trong README. Chưa có bộ nhân vật photoreal hoàn chỉnh, bản đồ Việt Nam chính xác, photogrammetry/scan được cấp quyền, animation đời thường hoàn thiện hoặc APK/IPA UE5 đã kiểm thử.

Mục tiêu là nâng chất lượng theo từng khu vực và công khai trạng thái thật của từng phần.
