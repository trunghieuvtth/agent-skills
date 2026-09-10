---
name: vietnam-government-document-nd30
description: Soạn thảo, rà soát, chuẩn hóa và kiểm định văn bản hành chính nhà nước Việt Nam theo Nghị định 30/2020/NĐ-CP. Tự kích hoạt khi người dùng yêu cầu công văn, quyết định, kế hoạch, báo cáo, tờ trình, thông báo, giấy mời, biên bản, thể thức, căn cứ pháp lý, thẩm quyền ký, DOCX/PDF hành chính hoặc nhắc Nghị định 30.
when_to_use: Dùng cho mọi tác vụ tạo, sửa, rà soát hoặc xuất văn bản hành chính Việt Nam và kiểm tra tuân thủ Nghị định 30.
license: MIT
metadata:
  author: Nguyen Trung Hieu
  version: 3.3.0
---

# ND30 Government Document Skill V3.3 Legal-Aware

Đây là bản đóng gói plugin của skill `vietnam-government-document-nd30`.

## Quy tắc bắt buộc

1. Phân loại đúng văn bản hành chính/VBQPPL trước khi soạn.
2. Không bịa số hiệu, ngày ban hành, điều/khoản/điểm, hiệu lực, thẩm quyền, người ký, số văn bản hoặc tên đơn vị.
3. Văn bản hành chính phải kiểm tra theo Nghị định 30/2020/NĐ-CP, đặc biệt Phụ lục I, II, III.
4. A4; lề trên 20–25 mm, dưới 20–25 mm, trái 30–35 mm, phải 15–20 mm; Times New Roman Unicode; bố cục không dùng nhiều Space/Enter để giả lập.
5. Công văn không có tên loại `CÔNG VĂN`.
6. Phân biệt cơ quan soạn thảo, cơ quan ban hành, người ký và tư cách ký; không mặc định Phó Giám đốc luôn ký `KT. GIÁM ĐỐC`.
7. Khi viện dẫn pháp luật phải kiểm tra legal identity: loại, số, ngày, cơ quan, tên/trích yếu, tình trạng hiệu lực và nguồn.
8. Nếu viện dẫn Điều/Khoản/Điểm phải xác minh đúng phiên bản hiện hành; chưa xác minh thì `LEGAL_GATE=VERIFY` và không Final.
9. Ưu tiên nguồn chính thức: CSDL quốc gia về VBPL, Cổng Chính phủ/Công báo, cơ quan ban hành. Không tạo URL pháp luật giả.
10. Khi tạo DOCX phải cấu hình thật page size, lề, font, paragraph, numbering, header, signature, nơi nhận, page number; sau đó parse/render để QA nếu công cụ cho phép.
11. Mỗi bản Final phải có khả năng tạo Legal Citation Report và kiểm tra căn cứ trùng, bị sửa đổi/thay thế hoặc không liên quan.
12. DRAFT có thể `VERIFY` với cảnh báo; FINAL không được có gate pháp lý/thẩm quyền/thể thức bắt buộc ở trạng thái FAIL hoặc VERIFY chưa xử lý.

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
docx: PASS
render: PASS
security: PASS
critical_errors: 0
major_errors: 0
```

Nếu thiếu một gate bắt buộc: `FINAL_READY = FALSE`.

## Workflow

`INPUT → CLASSIFY → LEGAL IDENTITY/STATUS/CITATION CHECK → AUTHORITY CHECK → DRAFT → CONTENT REVIEW → ND30 FORMAT → DOCX GENERATE → DOCX VALIDATE → RENDER → VISUAL QA → LEGAL CITATION REPORT → FINAL GATE`

## Source of truth

Bản canonical nằm tại `skills/vietnam-government-document-nd30/SKILL.md` trong cùng repository. Khi có quyền đọc repository, ưu tiên bản canonical nếu phiên bản của wrapper này cũ hơn.
