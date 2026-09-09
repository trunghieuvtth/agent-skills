# Install ND30 Skill V3.3

## ChatGPT

Nguồn chuẩn của skill nằm tại:

`skills/vietnam-government-document-nd30/SKILL.md`

Đối với ChatGPT, lưu bản Skill trong Library/Workspace/Project knowledge và dùng như instruction bắt buộc khi xử lý văn bản hành chính Việt Nam. Khi có task thuộc phạm vi Nghị định 30, phải load skill này trước khi soạn/rà soát.

## ZCode

Cách cài theo project/workspace:

1. Clone/pull repo `trunghieuvtth/agent-skills`.
2. Trỏ rules/skills của ZCode đến:

```text
skills/vietnam-government-document-nd30/SKILL.md
```

3. Thêm rule kích hoạt:

```text
For Vietnamese government administrative document drafting, review, formatting or legal citation validation, load vietnam-government-document-nd30 before producing the final result.
```

4. Nếu ZCode hỗ trợ global skills, symlink/copy folder `skills/vietnam-government-document-nd30` vào thư mục global skills của ZCode.

## Hermes

1. Clone/pull repo `trunghieuvtth/agent-skills` trên máy chạy Hermes.
2. Đăng ký folder:

```text
skills/vietnam-government-document-nd30/
```

làm skill source.

3. Trigger khuyến nghị:

```text
Nghị định 30
công văn
quyết định
kế hoạch
báo cáo
tờ trình
thông báo
văn bản hành chính
thể thức văn bản
căn cứ pháp lý
```

4. Hermes phải đọc `SKILL.md` trước khi thực hiện task phù hợp và không được bỏ qua Final Gate.

## Verification

Kiểm tra sau cài đặt bằng câu lệnh/prompt:

```text
Hãy cho biết skill nào sẽ được dùng để soạn một công văn hành chính của Sở Khoa học và Công nghệ theo Nghị định 30/2020/NĐ-CP. Chưa cần soạn công văn.
```

Kết quả mong đợi:

```text
vietnam-government-document-nd30 — version 3.3.0
```
