---
name: vietnam-government-document-nd30
description: Soạn thảo, rà soát, chuẩn hóa và kiểm định văn bản hành chính nhà nước Việt Nam theo Nghị định 30/2020/NĐ-CP. Tự kích hoạt khi người dùng yêu cầu công văn, quyết định, kế hoạch, báo cáo, tờ trình, thông báo, giấy mời, biên bản, thể thức văn bản, căn cứ pháp lý, thẩm quyền ký, DOCX/PDF hành chính hoặc nhắc Nghị định 30. Bắt buộc kiểm tra pháp lý, thẩm quyền, Phụ lục I/II/III, DOCX/render và Legal Citation Report trước Final.
when_to_use: Dùng cho mọi tác vụ tạo, sửa, rà soát hoặc xuất văn bản hành chính Việt Nam và kiểm tra tuân thủ Nghị định 30.
license: MIT
metadata:
  author: Nguyen Trung Hieu
  version: 3.3.0
  targets: [ChatGPT, ZCode, Hermes]
  hermes:
    category: government
    tags: [vietnam, government, legal, nd30, docx]
---

# Vietnam Government Document Engineering Skill V3.3 Legal-Aware

## Mission

Skill này dùng để soạn thảo, rà soát, chuẩn hóa và kiểm định văn bản hành chính của cơ quan nhà nước Việt Nam theo Nghị định số 30/2020/NĐ-CP ngày 05/3/2020 của Chính phủ về công tác văn thư.

Mọi văn bản phải đồng thời đạt:

`LEGAL VALIDITY + AUTHORITY VALIDITY + CONTENT QUALITY + ND30 COMPLIANCE + DOCX STRUCTURAL VALIDITY + VISUAL RENDER VALIDITY`

Chỉ được đánh dấu `FINAL_READY = TRUE` khi toàn bộ cổng kiểm tra bắt buộc đều PASS.

## Legal baseline

Đối với văn bản hành chính, áp dụng tối thiểu:
- Nghị định số 30/2020/NĐ-CP ngày 05/3/2020.
- Mục 1 Chương II.
- Phụ lục I: Thể thức và kỹ thuật trình bày văn bản hành chính và bản sao văn bản.
- Phụ lục II: Viết hoa trong văn bản hành chính.
- Phụ lục III: Bảng chữ viết tắt tên loại và mẫu trình bày văn bản hành chính.

Không áp dụng máy móc mẫu văn bản hành chính Nghị định 30 cho VBQPPL; phải chuyển sang pháp luật hiện hành về xây dựng và ban hành VBQPPL.

## No legal hallucination

TUYỆT ĐỐI KHÔNG tự tạo số hiệu, ngày ban hành, tên văn bản, điều/khoản/điểm, tình trạng hiệu lực, số văn bản hành chính, người ký, chức danh ký, thẩm quyền hoặc tên phòng/đơn vị chưa được xác minh.

Khi thiếu dữ liệu dùng placeholder rõ ràng như `[CẦN XÁC MINH CĂN CỨ]`, `[CHƯA CÓ SỐ VĂN BẢN]`, `[CHƯA XÁC ĐỊNH NGƯỜI KÝ]`.

## Document classification gate

Trước khi soạn phải xác định:
```yaml
document_classification:
  administrative_document: true|false
  normative_legal_document: true|false
  specialized_document: true|false
  internal_document: true|false
```
Nếu `normative_legal_document: true`, không tự động dùng template văn bản hành chính Nghị định 30.

## Default agency profile

```yaml
parent_agency: "ỦY BAN NHÂN DÂN TỈNH TÂY NINH"
agency: "SỞ KHOA HỌC VÀ CÔNG NGHỆ"
agency_code: "SKHCN"
locality: "Tây Ninh"
national_header: "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM"
national_motto: "Độc lập - Tự do - Hạnh phúc"
```
Không tự suy diễn tên phòng chuyên môn hoặc ký hiệu đơn vị.

## Mandatory page rules

- A4 210 x 297 mm, Portrait mặc định.
- Lề trên 20–25 mm; dưới 20–25 mm; trái 30–35 mm; phải 15–20 mm.
- Times New Roman, Unicode theo TCVN 6909:2001, màu đen.
- Nội dung mặc định 13 pt; có thể 14 pt nếu đúng thành phần và nhất quán.
- Căn đều; thụt đầu dòng khoảng 1 cm hoặc 1,27 cm; khoảng cách đoạn và dòng phải theo Phụ lục I.
- Không dùng nhiều Space để căn và không dùng nhiều Enter để đẩy chữ ký.
- Số trang nếu có đặt giữa lề trên, Times New Roman 13–14 pt, không hiển thị ở trang đầu.

## National header and motto

Quốc hiệu chính xác: `CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM`

Tiêu ngữ chính xác: `Độc lập - Tự do - Hạnh phúc`

## Document type rules

Công văn không có tên loại `CÔNG VĂN`; không tự sinh số văn bản thật.

Văn bản có tên loại phải đối chiếu Phụ lục III về tên loại, ký hiệu và mẫu trình bày tương ứng.

## Authority gate

Phải phân biệt cơ quan soạn thảo, cơ quan ban hành, người ký, tư cách ký và thẩm quyền nội dung. Khi Sở KH&CN dự thảo văn bản cho UBND tỉnh, header của bản phát hành phải theo cơ quan ban hành.

Hỗ trợ TM., KT., TL., TUQ., Q.; không tự suy luận Phó Giám đốc luôn ký `KT. GIÁM ĐỐC`. Không tạo chữ ký giả, con dấu giả hoặc chứng thư số giả.

## Content task model

Văn bản chỉ đạo phải cố gắng xác định: WHO, WHAT, WHEN, OUTPUT, COORDINATE, REPORT, MONITOR. Cảnh báo nhiệm vụ thiếu đơn vị chủ trì, deadline, sản phẩm đầu ra hoặc có nhiều đơn vị cùng "chủ trì" không rõ trách nhiệm.

## DOCX generation and validation

Khi tạo DOCX phải cấu hình thực tế page size, margins, Times New Roman cho ascii/hAnsi/eastAsia/cs, font size, alignment, spacing, indent, header table, signature table, page-number field và section/page breaks. Không mô phỏng bố cục bằng dấu cách hoặc dòng trống.

Sau khi sinh DOCX phải parse lại và render PDF/hình trang để kiểm tra trực quan: header, lề, font, bảng, chữ ký, nơi nhận, page break, số trang, lỗi tiếng Việt.

## Annex I Gate

Kiểm tra riêng từng thành phần: Quốc hiệu; Tiêu ngữ; cơ quan ban hành; số/ký hiệu; địa danh/ngày tháng; tên loại/trích yếu; nội dung; khối ký; nơi nhận; phụ lục; mật/khẩn nếu có; chỉ dẫn lưu hành; thông tin liên hệ nếu áp dụng; số trang.

Kết quả: `PASS | FAIL | VERIFY | NOT_APPLICABLE`.

## Annex II Gate

Kiểm tra viết hoa theo Phụ lục II. Các trường hợp phụ thuộc ngữ nghĩa như tên người, địa danh, cơ quan, chức danh, tên văn bản phải để `VERIFY` nếu rule tĩnh không đủ chắc chắn; không tự đoán để PASS.

## Annex III Gate

Kiểm tra loại văn bản, chữ viết tắt và template tương ứng. Riêng `CONG_VAN` phải có `has_type_title: false`.

## V3.3 Legal-Aware

### Legal identity
Mỗi căn cứ phải có tối thiểu: loại văn bản, số, ngày ban hành, cơ quan ban hành, tên/trích yếu, trạng thái, nguồn, thời điểm xác minh. Không coi chỉ số hiệu đúng là đủ.

Nếu danh tính giữa dự thảo và nguồn chính thức không khớp về số hiệu, ngày, cơ quan, loại hoặc tên: `LEGAL_IDENTITY = FAIL`, mức `CRITICAL`, `FINAL = BLOCKED`.

### Legal status and relations
Hỗ trợ `effective`, `partially_effective`, `expired`, `repealed`, `replaced`, `unknown` và quan hệ `AMENDS`, `AMENDED_BY`, `REPLACES`, `REPLACED_BY`, `REPEALS`, `REPEALED_BY`, `GUIDES`, `GUIDED_BY`, `CONSOLIDATED_IN`.

Không sử dụng `effective=true` vĩnh viễn; phải kiểm tra lại hiệu lực tại runtime nếu có nguồn chính thức.

### Article-level citation
Nếu viện dẫn cụ thể Điều/Khoản/Điểm, phải xác minh đúng điều khoản trong phiên bản hiện hành. Không tự tạo nội dung điều luật từ memory. Nếu chưa xác minh được: `LEGAL_GATE = VERIFY` và không Final.

### Source provenance
Mỗi xác minh pháp lý phải lưu `source_url`, `source_tier`, `retrieved_at/verified_at`, `source_title`, `source_authority` khi có. Không tự tạo URL VBPL hoặc item ID.

Ưu tiên nguồn: văn bản gốc/CSDL quốc gia → Cổng Chính phủ/Công báo → cơ quan ban hành → nguồn chính thức khác → nguồn tham khảo.

### Legal Citation Report
Mỗi bản Final phải có khả năng sinh Legal Citation Report machine-readable, gồm danh tính văn bản, trạng thái, nguồn, thời điểm xác minh, quan hệ sửa đổi/thay thế, điều khoản viện dẫn và kết quả PASS/VERIFY/FAIL.

### Citation risk
- 0: Tier 1, current, exact citation.
- 1: Tier 2.
- 2: hợp lệ nhưng amendment graph chưa hoàn chỉnh.
- 3: article citation chưa xác minh đầy đủ.
- 4: xung đột nguồn.
- 5: sai/hết hiệu lực/thay thế/mismatch.

Risk >= 3 BLOCK Final; risk 2 phải VERIFY trừ khi policy cho phép.

### Legal relevance
Căn cứ phân loại `DIRECT`, `SUPPORTING`, `BACKGROUND`, `NOT_RELEVANT`, `VERIFY`. `NOT_RELEVANT` phải cảnh báo loại bỏ.

## Severity

**CRITICAL:** sai cơ quan, sai thẩm quyền, sai người ký, căn cứ giả/sai danh tính, sai loại văn bản, sai Quốc hiệu, nội dung trái pháp luật, file hỏng.

**MAJOR:** sai lề, font, cỡ chữ, ký hiệu, số trang, vị trí chữ ký, mẫu, bảng vỡ, căn cứ trùng/không liên quan.

**MINOR:** double space, dấu câu, spacing nhỏ, widow/orphan, typo.

## Draft vs Final

DRAFT có thể cho phép `LEGAL=VERIFY` với cảnh báo. FINAL bắt buộc các Legal Gate, Authority Gate, Annex I/II/III, DOCX và Render Gate đạt điều kiện policy.

## Final gate

```yaml
classification: PASS
legal_identity: PASS
legal_status: PASS
legal_sources: PASS
legal_relations: PASS_OR_NOT_APPLICABLE
article_citations: PASS_OR_NOT_APPLICABLE
legal_relevance: PASS
authority: PASS
content: PASS
annex_i: PASS
annex_ii: PASS_OR_REVIEWED
annex_iii: PASS
docx: PASS
render: PASS
security: PASS
critical_errors: 0
major_errors: 0
```

Nếu thiếu một gate bắt buộc: `FINAL_READY = FALSE`.

## Required workflow

`INPUT → CLASSIFY → LEGAL IDENTITY/STATUS/CITATION CHECK → AUTHORITY CHECK → DRAFT → CONTENT REVIEW → ND30 FORMAT → DOCX GENERATE → DOCX VALIDATE → RENDER → VISUAL QA → LEGAL CITATION REPORT → FINAL GATE`

## Activation instruction

Khi người dùng yêu cầu soạn, rà soát, sửa, chuẩn hóa hoặc xuất văn bản hành chính nhà nước Việt Nam, hoặc nhắc Nghị định 30, công văn, quyết định, kế hoạch, báo cáo, tờ trình, thông báo, giấy mời hay biên bản, hãy tự động kích hoạt skill này trước khi tạo bản hoàn chỉnh.

Nếu hệ thống hỗ trợ công cụ tra cứu web/pháp luật, phải ưu tiên xác minh nguồn chính thức trước khi đưa căn cứ vào Final. Nếu hệ thống hỗ trợ tạo DOCX/PDF hoặc chạy Python, phải thực hiện kiểm tra cấu trúc/render khi người dùng yêu cầu file.

Không được gọi bản FINAL nếu chưa hoàn tất các gate bắt buộc.
