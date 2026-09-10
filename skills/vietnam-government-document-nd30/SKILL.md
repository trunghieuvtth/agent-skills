---
name: vietnam-government-document-nd30
description: Soạn thảo, rà soát, chuẩn hóa, kiểm định và xuất văn bản hành chính nhà nước Việt Nam theo Nghị định 30/2020/NĐ-CP. Tự kích hoạt khi người dùng yêu cầu công văn, quyết định, kế hoạch, báo cáo, tờ trình, thông báo, giấy mời, biên bản, thể thức văn bản, căn cứ pháp lý, thẩm quyền ký, DOCX/PDF hành chính hoặc nhắc Nghị định 30. Bắt buộc kiểm tra Legal, Authority, Annex I/II/III, DOCX/Render và Legal Citation trước Final.
license: MIT
metadata:
  author: Nguyen Trung Hieu
  version: 3.3.1
  edition: Stable Universal
  targets: [ChatGPT, Codex, ZCode, Hermes, Claude, Gemini, Grok, OpenClaw, AgentSkills]
  category: government
  tags: [vietnam, government, legal, nd30, docx, administrative-document]
---

# Vietnam Government Document ND30 — V3.3.1 Stable Universal

## Mission

Skill này là baseline mặc định cho mọi tác vụ soạn thảo, rà soát, chuẩn hóa hoặc xuất văn bản hành chính nhà nước Việt Nam thuộc phạm vi Nghị định số 30/2020/NĐ-CP.

Mục tiêu bắt buộc:

`LEGAL VALIDITY + AUTHORITY VALIDITY + CONTENT QUALITY + ND30 COMPLIANCE + DOCX STRUCTURAL VALIDITY + VISUAL RENDER VALIDITY`

Chỉ được coi là Final khi các gate bắt buộc đạt yêu cầu.

## Auto-activation

Tự kích hoạt khi yêu cầu có một hoặc nhiều tín hiệu sau:

- công văn, quyết định cá biệt, chỉ thị, quy chế, quy định, thông cáo, thông báo, hướng dẫn;
- chương trình, kế hoạch, phương án, đề án, dự án, báo cáo, biên bản, tờ trình;
- hợp đồng, công điện, bản ghi nhớ, bản thỏa thuận;
- giấy ủy quyền, giấy mời, giấy giới thiệu, giấy nghỉ phép;
- phiếu gửi, phiếu chuyển, phiếu báo, thư công;
- Nghị định 30, thể thức văn bản, văn thư, số/ký hiệu, nơi nhận, khối ký;
- căn cứ pháp lý, thẩm quyền ký, kiểm tra Điều/Khoản/Điểm;
- tạo/kiểm tra DOCX hoặc PDF văn bản hành chính.

Không cần người dùng gọi đúng tên Skill.

## Capability detection

Trước khi thực hiện, tự xác định môi trường có những khả năng nào:

```yaml
capabilities:
  web_or_legal_search: true|false
  filesystem: true|false
  python_or_code_execution: true|false
  docx_generation: true|false
  pdf_render: true|false
  image_or_visual_inspection: true|false
```

Nguyên tắc:

- Có web/legal search → xác minh căn cứ từ nguồn chính thức.
- Không có web → Legal Gate tối đa là `VERIFY`, không tự nâng thành `PASS`.
- Có DOCX/code execution → tạo file thật và parse lại cấu trúc.
- Có PDF render/vision → render và kiểm tra trực quan.
- Không có công cụ tương ứng → nêu rõ gate chưa thể kiểm chứng, không giả lập kết quả.

## Legal baseline

Baseline pháp lý nhận diện:

- Nghị định số 30/2020/NĐ-CP ngày 05/3/2020 của Chính phủ về công tác văn thư.
- Mục 1 Chương II.
- Phụ lục I: Thể thức và kỹ thuật trình bày văn bản hành chính và bản sao văn bản.
- Phụ lục II: Viết hoa trong văn bản hành chính.
- Phụ lục III: Bảng chữ viết tắt tên loại và mẫu trình bày văn bản hành chính.

Không hard-code tình trạng hiệu lực vĩnh viễn. Khi có khả năng tra cứu, phải re-check trạng thái tại runtime trước Final.

## Classification Gate

Trước khi soạn phải phân loại:

```yaml
document_classification:
  administrative_document: true|false
  normative_legal_document: true|false
  specialized_document: true|false
  internal_document: true|false
```

Nếu `normative_legal_document: true`, không áp dụng máy móc template văn bản hành chính của Nghị định 30; phải chuyển sang pháp luật hiện hành về xây dựng và ban hành VBQPPL.

## No legal hallucination

TUYỆT ĐỐI KHÔNG tự tạo:

- số hiệu, ngày ban hành, tên/trích yếu văn bản pháp luật;
- điều, khoản, điểm;
- tình trạng hiệu lực;
- quan hệ sửa đổi, thay thế, bãi bỏ;
- số văn bản hành chính thật;
- người ký, chức danh ký, ủy quyền;
- tên phòng/đơn vị chưa được xác minh;
- URL nguồn pháp luật, item ID hoặc citation giả.

Nếu chưa xác minh, dùng placeholder/flag rõ ràng:

`[CẦN XÁC MINH CĂN CỨ]`
`[CHƯA CÓ SỐ VĂN BẢN]`
`[CHƯA XÁC ĐỊNH NGƯỜI KÝ]`
`VERIFY`

## Default agency profile

```yaml
parent_agency: "ỦY BAN NHÂN DÂN TỈNH TÂY NINH"
agency: "SỞ KHOA HỌC VÀ CÔNG NGHỆ"
agency_code: "SKHCN"
locality: "Tây Ninh"
national_header: "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM"
national_motto: "Độc lập - Tự do - Hạnh phúc"
```

Profile chỉ là mặc định. Nếu người dùng/cơ quan khác cung cấp dữ liệu, dữ liệu xác minh mới được ưu tiên.

## ND30 page rules

- A4: 210 × 297 mm.
- Portrait mặc định; Landscape chỉ khi nội dung bảng/biểu phù hợp.
- Lề trên: 20–25 mm.
- Lề dưới: 20–25 mm.
- Lề trái: 30–35 mm.
- Lề phải: 15–20 mm.
- Times New Roman, Unicode theo TCVN 6909:2001, màu đen.
- Nội dung thường 13–14 pt theo đúng thành phần.
- Không dùng nhiều Space để căn bố cục.
- Không dùng nhiều Enter để đẩy chữ ký/nơi nhận.
- Số trang: số Ả Rập, giữa lề trên, 13–14 pt, trang đầu được tính nhưng không hiển thị.

## Exact mandatory text

Quốc hiệu:

`CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM`

Tiêu ngữ:

`Độc lập - Tự do - Hạnh phúc`

Không tự đổi nội dung, dấu nối hoặc kiểu viết hoa.

## Document type rules

Công văn:

```yaml
has_type_title: false
```

Không được thêm dòng `CÔNG VĂN` làm tên loại.

Các văn bản có tên loại phải đối chiếu Phụ lục III về tên loại, chữ viết tắt và mẫu trình bày.

## Authority Gate

Phải phân biệt:

- cơ quan soạn thảo;
- cơ quan ban hành;
- người ký;
- tư cách ký;
- thẩm quyền nội dung;
- căn cứ phân công/ủy quyền nếu có.

Khi Sở KH&CN dự thảo văn bản để UBND tỉnh ban hành, header của bản phát hành phải theo UBND tỉnh, không theo cơ quan soạn thảo.

Không tự suy luận Phó Giám đốc luôn ký `KT. GIÁM ĐỐC`.

Hỗ trợ TM., KT., TL., TUQ., Q. khi có căn cứ phù hợp.

## Legal-Aware Gate

Mỗi căn cứ pháp lý phải có tối thiểu:

```yaml
legal_identity:
  document_type:
  number:
  issued_date:
  issuing_authority:
  title:
  effective_status:
  source_url:
  source_tier:
  verified_at:
  verified:
```

Chỉ số hiệu đúng không đủ để PASS.

Nếu số hiệu/ngày/cơ quan/loại/tên không khớp nguồn chính thức:

`LEGAL_IDENTITY = FAIL`
`SEVERITY = CRITICAL`
`FINAL = BLOCKED`

## Legal status and relations

Hỗ trợ trạng thái:

`effective | partially_effective | expired | repealed | replaced | unknown`

Hỗ trợ quan hệ:

`AMENDS | AMENDED_BY | REPLACES | REPLACED_BY | REPEALS | REPEALED_BY | GUIDES | GUIDED_BY | CONSOLIDATED_IN`

Không dùng trạng thái hiệu lực từ memory làm bằng chứng Final.

## Article-level citation

Nếu viện dẫn Điều/Khoản/Điểm cụ thể, phải xác minh:

```yaml
citation:
  article:
  clause:
  point:
  source_verified:
  current_version_verified:
  text_match:
```

Nếu chưa xác minh điều khoản hiện hành:

`ARTICLE_CITATION = VERIFY`
`FINAL_READY = FALSE`

## Source provenance

Thứ tự ưu tiên:

1. CSDL quốc gia về VBPL / văn bản gốc.
2. Cổng Thông tin điện tử Chính phủ / Công báo.
3. Cơ quan ban hành.
4. Nguồn chính thức `.gov.vn` khác.
5. Nguồn tham khảo.

Blog/diễn đàn/bài viết tổng hợp không được dùng làm nguồn duy nhất để PASS căn cứ pháp lý.

Nếu nguồn xung đột: `SOURCE_CONFLICT = TRUE`, `LEGAL_GATE = VERIFY`.

## Legal relevance

Phân loại căn cứ:

`DIRECT | SUPPORTING | BACKGROUND | NOT_RELEVANT | VERIFY`

Căn cứ `NOT_RELEVANT` phải cảnh báo loại bỏ.

## Content quality gate

Với văn bản chỉ đạo/giao việc, kiểm tra:

`WHO → WHAT → WHEN → OUTPUT → COORDINATE → REPORT → MONITOR`

Cảnh báo thiếu đơn vị chủ trì, deadline rõ ràng, sản phẩm đầu ra hoặc phân vai trách nhiệm.

## Annex I Gate

Kiểm tra riêng từng thành phần: Quốc hiệu; Tiêu ngữ; cơ quan ban hành; số/ký hiệu; địa danh/ngày tháng; tên loại/trích yếu; nội dung; khối ký; nơi nhận; phụ lục; mật/khẩn nếu có; phạm vi lưu hành nếu có; thông tin liên hệ nếu áp dụng; số trang.

Kết quả mỗi thành phần:

`PASS | FAIL | VERIFY | NOT_APPLICABLE`

## Annex II Gate

Kiểm tra viết hoa theo Phụ lục II. Các trường hợp phụ thuộc ngữ nghĩa phải để `VERIFY` nếu rule tĩnh không đủ chắc chắn; không đoán để PASS.

## Annex III Gate

Kiểm tra loại văn bản, tên loại, chữ viết tắt, mẫu trình bày và thành phần bắt buộc. Riêng Công văn phải không có tên loại.

## DOCX Generation Gate

Khi môi trường có khả năng tạo DOCX, phải cấu hình thực tế page size, margins, Times New Roman cho ascii/hAnsi/eastAsia/cs, cỡ chữ, alignment, paragraph spacing, first-line indent, bảng không viền, page/section break, page-number field, signature block và recipient block.

Không chỉ xuất Markdown rồi đổi đuôi `.docx`.

## DOCX Parse-back Gate

Sau khi tạo DOCX phải đọc ngược lại để kiểm tra section dimensions, margins, font/runs, headers/footers, tables, numbering, page number fields, signature/recipient blocks.

## Render Gate

Nếu môi trường có khả năng render PDF/hình trang, phải kiểm tra trực quan: header, lề, bảng, font, dấu tiếng Việt, page break, chữ ký, nơi nhận, số trang.

Nếu không có renderer: `RENDER = VERIFY`, không giả `PASS`.

## Signature security

Không tạo chữ ký giả, con dấu giả, chứng thư số giả, token PIN, private key hoặc mật khẩu ký số.

## Severity

### CRITICAL
Sai cơ quan, sai thẩm quyền, sai người ký, căn cứ giả/sai danh tính, sai loại văn bản, sai Quốc hiệu, nội dung trái pháp luật, file hỏng.

### MAJOR
Sai lề, font, cỡ chữ, ký hiệu, số trang, khối ký, mẫu, bảng vỡ, căn cứ trùng/không liên quan.

### MINOR
Khoảng trắng, dấu câu, spacing nhỏ, widow/orphan, typo.

## Draft vs Final

DRAFT có thể tồn tại gate `VERIFY`, nhưng phải nêu rõ.

FINAL không được phép nếu còn gate bắt buộc `VERIFY`/`FAIL`, trừ gate thực sự `NOT_APPLICABLE` hoặc đã có xác nhận thủ công theo policy.

## Legal Citation Report

Bản Final có căn cứ pháp lý phải có khả năng tạo báo cáo gồm danh tính từng văn bản, trạng thái hiệu lực, nguồn, thời điểm xác minh, quan hệ sửa đổi/thay thế, Điều/Khoản/Điểm được viện dẫn và PASS/VERIFY/FAIL.

## Final Gate

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
docx: PASS_OR_NOT_APPLICABLE
render: PASS_OR_NOT_APPLICABLE
security: PASS
critical_errors: 0
major_errors: 0
unresolved_placeholders: 0
```

Nếu thiếu gate bắt buộc: `FINAL_READY = FALSE`.

## Required workflow

`INPUT → CLASSIFY → CAPABILITY DETECT → LEGAL IDENTITY/STATUS/CITATION → AUTHORITY → DRAFT → CONTENT REVIEW → ANNEX I/II/III → DOCX → PARSE-BACK → RENDER → VISUAL QA → LEGAL CITATION REPORT → FINAL GATE`

## Model-neutral execution contract

Skill phải hoạt động nhất quán trên mọi model. Thiếu tool chỉ làm gate chuyển sang `VERIFY` hoặc `NOT_APPLICABLE` khi thực sự không áp dụng; model không được tự đổi policy để báo PASS.

Nếu hệ thống hỗ trợ subagent/tool/plugin phù hợp, có thể phân vai nhưng kết quả cuối vẫn phải hợp nhất về cùng Final Gate.

## Progressive disclosure

Không nạp toàn bộ engine/config nếu không cần. Ưu tiên: đọc SKILL.md → chỉ đọc config/template đúng loại văn bản → chỉ chạy validator cần thiết → chỉ tạo Legal Citation Report khi có căn cứ pháp lý hoặc người dùng yêu cầu Final.

## Self-test after installation

Test 1:

`Hãy cho biết Skill nào cần dùng để rà soát một công văn hành chính theo Nghị định 30/2020/NĐ-CP. Chưa cần soạn văn bản.`

Kết quả mong đợi:

`vietnam-government-document-nd30 — Version 3.3.1`

Test 2:

`Hãy rà soát một dự thảo công văn có căn cứ pháp lý chưa được xác minh và cho biết có được đánh dấu FINAL không.`

Kết quả đúng: không Final; Legal Gate phải là `VERIFY` hoặc `FAIL` tùy dữ liệu.

## Universal compatibility

Thiết kế cho ChatGPT/Codex, ZCode, Hermes, Claude Code, Gemini CLI, Grok CLI, OpenClaw và agent theo chuẩn Agent Skills/SKILL.md.

Nền tảng web không có local skill folder phải dùng upload/import/plugin/knowledge tương ứng; không được báo “đã cài” nếu runtime không cho phép.

## Non-negotiable rule

**Đúng pháp luật + đúng thẩm quyền + đúng nội dung + đúng thể thức Nghị định 30 + đúng kỹ thuật file + có bằng chứng kiểm chứng.**
