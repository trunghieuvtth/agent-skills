# ND30 Templates — V3.3.1

Bộ mẫu này dùng cho `vietnam-government-document-nd30` và được thiết kế theo Nghị định 30/2020/NĐ-CP, đặc biệt Phụ lục I, II, III.

## Nguyên tắc chung

- Khổ A4 210 x 297 mm; mặc định dọc.
- Lề: trên 20–25 mm; dưới 20–25 mm; trái 30–35 mm; phải 15–20 mm.
- Times New Roman, Unicode; màu đen.
- Không dùng nhiều dấu cách để căn dòng; không dùng nhiều dòng trống để đẩy chữ ký.
- Header trái/phải, khối số-ngày, chữ ký và nơi nhận phải được bố trí bằng table không viền/tab/alignment thực tế khi sinh DOCX.
- Không tự tạo số văn bản, người ký, chức danh, căn cứ pháp lý hoặc tên đơn vị chưa xác minh.
- Placeholder bắt buộc dùng dạng `[CHƯA ...]` hoặc `[CẦN XÁC MINH ...]`.
- Công văn không có tên loại `CÔNG VĂN`.
- Mọi văn bản Final phải vượt qua Legal, Authority, Annex I/II/III, DOCX và Render Gate.

## Bộ mẫu chính

1. `cong_van.yaml`
2. `quyet_dinh.yaml`
3. `ke_hoach.yaml`
4. `bao_cao.yaml`
5. `to_trinh.yaml`
6. `thong_bao.yaml`
7. `giay_moi.yaml`

Các file YAML là schema/template logic, không phải văn bản đã ký hoặc phát hành. Giá trị về số, ngày, người ký, căn cứ và nơi nhận phải lấy từ dữ liệu thực tế trước khi xuất Final.
