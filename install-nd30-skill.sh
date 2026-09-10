#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="vietnam-government-document-nd30"
VERSION="3.3.1"
REPO="trunghieuvtth/agent-skills"
BASE_RAW="https://raw.githubusercontent.com/${REPO}/main/skills/${SKILL_NAME}"
RAW_URL="${BASE_RAW}/SKILL.md"
REPO_URL="https://github.com/${REPO}.git"
MODE="${1:-auto}"

TEMPLATE_FILES=(
  "README.md"
  "shared_layout.yaml"
  "template_registry.yaml"
  "generic_named_document.yaml"
  "cong_van.yaml"
  "quyet_dinh.yaml"
  "ke_hoach.yaml"
  "bao_cao.yaml"
  "to_trinh.yaml"
  "thong_bao.yaml"
  "giay_moi.yaml"
)

log(){ printf '%s\n' "$*"; }
has(){ command -v "$1" >/dev/null 2>&1; }

download_bundle(){
  local dest="$1"
  mkdir -p "$dest/templates"
  curl -fsSL "$RAW_URL" -o "$dest/SKILL.md"
  grep -q '^name: vietnam-government-document-nd30$' "$dest/SKILL.md"
  grep -q '3.3.1' "$dest/SKILL.md"
  local f
  for f in "${TEMPLATE_FILES[@]}"; do
    curl -fsSL "${BASE_RAW}/templates/${f}" -o "$dest/templates/${f}"
  done
  test -s "$dest/templates/template_registry.yaml"
  test -s "$dest/templates/cong_van.yaml"
}

install_zcode(){ local d="$HOME/.zcode/skills/$SKILL_NAME"; download_bundle "$d"; log "[OK] ZCode       -> $d"; }
install_hermes(){ local d="$HOME/.hermes/skills/government/$SKILL_NAME"; download_bundle "$d"; log "[OK] Hermes      -> $d"; }
install_claude(){ local d="$HOME/.claude/skills/$SKILL_NAME"; download_bundle "$d"; log "[OK] Claude Code -> $d"; }
install_grok(){ local d="$HOME/.grok/skills/$SKILL_NAME"; download_bundle "$d"; log "[OK] Grok CLI    -> $d"; }
install_openclaw(){ local d="$HOME/.openclaw/skills/$SKILL_NAME"; download_bundle "$d"; log "[OK] OpenClaw    -> $d"; }
install_codex(){ local home="${CODEX_HOME:-$HOME/.codex}"; local d="$home/skills/$SKILL_NAME"; download_bundle "$d"; log "[OK] Codex       -> $d"; }
install_gemini(){
  if has gemini; then
    if gemini skills install "$REPO_URL" --path "skills/$SKILL_NAME" --scope user --consent >/dev/null 2>&1; then
      log "[OK] Gemini CLI  -> native repository installer"
      return
    fi
  fi
  local d="$HOME/.gemini/skills/$SKILL_NAME"; download_bundle "$d"; log "[OK] Gemini CLI  -> $d (fallback)"
}
chatgpt_note(){
  log "[INFO] ChatGPT web/app cannot be modified by a local shell installer."
  log "       Import/upload the complete skill folder or package in the ChatGPT Skills/Workspace UI when available."
  log "       Canonical source: https://github.com/$REPO/tree/main/skills/$SKILL_NAME"
}
claude_web_note(){ log "[INFO] Claude.ai web account requires UI import; Claude Code local install is supported."; }
grok_web_note(){ log "[INFO] Grok web account requires UI/import support; Grok CLI local install is supported."; }

install_target(){
  case "$1" in
    zcode) install_zcode;;
    hermes) install_hermes;;
    claude|claude-code) install_claude;;
    grok|grok-cli) install_grok;;
    openclaw) install_openclaw;;
    codex) install_codex;;
    gemini|germini) install_gemini;;
    chatgpt) chatgpt_note;;
    all)
      install_zcode; install_hermes; install_claude; install_grok; install_openclaw; install_codex; install_gemini
      chatgpt_note; claude_web_note; grok_web_note
      ;;
    *) log "Unknown target: $1"; return 2;;
  esac
}

auto_install(){
  local found=0
  if has zcode || [ -d "$HOME/.zcode" ]; then install_zcode; found=1; fi
  if has hermes || [ -d "$HOME/.hermes" ]; then install_hermes; found=1; fi
  if has claude || [ -d "$HOME/.claude" ]; then install_claude; found=1; fi
  if has grok || [ -d "$HOME/.grok" ]; then install_grok; found=1; fi
  if has openclaw || [ -d "$HOME/.openclaw" ]; then install_openclaw; found=1; fi
  if has codex || [ -n "${CODEX_HOME:-}" ] || [ -d "$HOME/.codex" ]; then install_codex; found=1; fi
  if has gemini || [ -d "$HOME/.gemini" ]; then install_gemini; found=1; fi
  if [ -d "$HOME/.agents/skills" ]; then download_bundle "$HOME/.agents/skills/$SKILL_NAME"; log "[OK] AgentSkills -> $HOME/.agents/skills/$SKILL_NAME"; found=1; fi
  if [ "$found" -eq 0 ]; then
    log "No supported local AI runtime detected."
    log "Use '$0 all' to provision all supported local skill locations, or pass a target name."
  fi
  chatgpt_note
}

case "$MODE" in
  auto) auto_install;;
  all|zcode|hermes|claude|claude-code|grok|grok-cli|openclaw|codex|gemini|germini|chatgpt) install_target "$MODE";;
  *) log "Usage: $0 [auto|all|zcode|hermes|claude|grok|openclaw|codex|gemini|chatgpt]"; exit 2;;
esac

log ""
log "ND30 Skill $VERSION deployment finished."
log "Installed bundle includes SKILL.md + templates/."
log "Canonical source: https://github.com/$REPO/tree/main/skills/$SKILL_NAME"
