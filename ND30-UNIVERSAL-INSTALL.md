# ND30 V3.3 — Universal Multi-Model Installer

Canonical skill: `vietnam-government-document-nd30` v3.3.0.

## One command — Linux / macOS / WSL

```bash
curl -fsSL https://raw.githubusercontent.com/trunghieuvtth/agent-skills/main/install-nd30-skill.sh | bash -s -- auto
```

The installer detects locally available runtimes and installs only where detected.

To provision every supported local skill location:

```bash
curl -fsSL https://raw.githubusercontent.com/trunghieuvtth/agent-skills/main/install-nd30-skill.sh | bash -s -- all
```

## One command — Windows PowerShell

```powershell
$u='https://raw.githubusercontent.com/trunghieuvtth/agent-skills/main/install-nd30-skill.ps1'; $p="$env:TEMP\install-nd30-skill.ps1"; irm $u -OutFile $p; & $p auto
```

Use `all` instead of `auto` to provision every supported local skill location.

## Detection / destination matrix

| Runtime | Detection | Install destination / mechanism |
|---|---|---|
| ZCode | `zcode` or `~/.zcode` | `~/.zcode/skills/vietnam-government-document-nd30/SKILL.md` |
| Hermes | `hermes` or `~/.hermes` | native `hermes skills install`, fallback `~/.hermes/skills/...` |
| Claude Code | `claude` or `~/.claude` | `~/.claude/skills/vietnam-government-document-nd30/SKILL.md` |
| Grok CLI | `grok` or `~/.grok` | `~/.grok/skills/vietnam-government-document-nd30/SKILL.md` |
| OpenClaw | `openclaw` or `~/.openclaw` | `~/.openclaw/skills/vietnam-government-document-nd30/SKILL.md` |
| Codex | `codex`, `$CODEX_HOME`, or `~/.codex` | `${CODEX_HOME:-~/.codex}/skills/vietnam-government-document-nd30/SKILL.md` |
| Gemini CLI | `gemini` or `~/.gemini` | native `gemini skills install`; fallback user skill folder |
| AgentSkills compatible | existing `~/.agents/skills` | `~/.agents/skills/vietnam-government-document-nd30/SKILL.md` |
| ChatGPT web/app | not a shell runtime | installer prints the canonical source and UI import guidance |
| Claude.ai / Grok web | not shell runtimes | import/upload through the product UI if that surface supports custom skills |

## Explicit target

```bash
# examples
bash install-nd30-skill.sh zcode
bash install-nd30-skill.sh hermes
bash install-nd30-skill.sh claude
bash install-nd30-skill.sh grok
bash install-nd30-skill.sh openclaw
bash install-nd30-skill.sh codex
bash install-nd30-skill.sh gemini
```

## Automatic activation

The canonical `SKILL.md` uses Agent Skills YAML frontmatter with `name` and a trigger-focused `description`. Compatible agents can therefore discover the skill and load it when a task matches Vietnamese government administrative-document drafting/review, Nghị định 30, Công văn, Quyết định, Kế hoạch, Báo cáo, Tờ trình, Thông báo, Giấy mời, Biên bản, legal-basis checking, authority checking, or DOCX compliance.

## Verification

After installation, test with:

> Hãy cho biết Skill nào cần sử dụng để rà soát một công văn hành chính theo Nghị định 30/2020/NĐ-CP. Chưa cần soạn văn bản.

Expected skill name:

`vietnam-government-document-nd30`

Expected version:

`3.3.0`

## Security

The installer downloads only the canonical `SKILL.md` from this repository. It does not request API keys, passwords, tokens, OTPs, signing certificates, or private keys.

Before running a remote shell installer in a high-security environment, review the script in this repository first.
