#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="vietnam-government-document-nd30"
VERSION="3.3.0"
REPO="trunghieuvtth/agent-skills"
RAW_URL="https://raw.githubusercontent.com/${REPO}/main/skills/${SKILL_NAME}/SKILL.md"
REPO_URL="https://github.com/${REPO}.git"
MODE="${1:-auto}"

log(){ printf '%s\n' "$*"; }
has(){ command -v "$1" >/dev/null 2>&1; }
download_to(){
  local dest="$1"
  mkdir -p "$dest"
  curl -fsSL "$RAW_URL" -o "$dest/SKILL.md"
  grep -q '^name: vietnam-government-document-nd30$' "$dest/SKILL.md"
  grep -q '3.3.0' "$dest/SKILL.md"
}

install_zcode(){
  local d="$HOME/.zcode/skills/$SKILL_NAME"
  download_to "$d"
  log "[OK] ZCode      -> $d/SKILL.md"
}

install_hermes(){
  if has hermes; then
    if hermes skills install "$RAW_URL" --now >/dev/null 2>&1; then
      log "[OK] Hermes     -> native installer"
      return
    fi
  fi
  local d="$HOME/.hermes/skills/government/$SKILL_NAME"
  download_to "$d"
  log "[OK] Hermes     -> $d/SKILL.md"
}

install_claude(){
  local d="$HOME/.claude/skills/$SKILL_NAME"
  download_to "$d"
  log "[OK] Claude Code -> $d/SKILL.md"
}

install_grok(){
  local d="$HOME/.grok/skills/$SKILL_NAME"
  download_to "$d"
  log "[OK] Grok CLI    -> $d/SKILL.md"
}

install_openclaw(){
  local d="$HOME/.openclaw/skills/$SKILL_NAME"
  download_to "$d"
  log "[OK] OpenClaw    -> $d/SKILL.md"
}

install_codex(){
  local home="${CODEX_HOME:-$HOME/.codex}"
  local d="$home/skills/$SKILL_NAME"
  download_to "$d"
  log "[OK] Codex       -> $d/SKILL.md"
}

install_gemini(){
  if has gemini; then
    if gemini skills install "$REPO_URL" --path "skills/$SKILL_NAME" --scope user --consent >/dev/null 2>&1; then
      log "[OK] Gemini CLI  -> native installer"
      return
    fi
  fi
  # Agent Skills user-level fallback used by recent Gemini CLI builds.
  local d="$HOME/.gemini/skills/$SKILL_NAME"
  download_to "$d"
  log "[OK] Gemini CLI  -> $d/SKILL.md (fallback)"
}

chatgpt_note(){
  log "[INFO] ChatGPT web/app: shell install is not available."
  log "       Use Plugins -> Skills -> Create -> Upload from computer on an eligible account."
  log "       Source: $RAW_URL"
}

claude_web_note(){
  log "[INFO] Claude.ai: local shell installer cannot write into the web account; upload/import the skill in Claude UI if supported by your plan."
}

grok_web_note(){
  log "[INFO] Grok web: local shell installer cannot write into the web account. Grok CLI is supported by this installer."
}

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

  # Shared Agent Skills fallback: useful to agents that follow agentskills.io / ~/.agents/skills.
  if [ -d "$HOME/.agents/skills" ]; then
    download_to "$HOME/.agents/skills/$SKILL_NAME"
    log "[OK] AgentSkills -> $HOME/.agents/skills/$SKILL_NAME/SKILL.md"
    found=1
  fi

  if [ "$found" -eq 0 ]; then
    log "No supported local AI runtime detected."
    log "Use '$0 all' to provision all local skill locations, or install a named target."
  fi
  chatgpt_note
}

case "$MODE" in
  auto) auto_install;;
  all|zcode|hermes|claude|claude-code|grok|grok-cli|openclaw|codex|gemini|germini|chatgpt) install_target "$MODE";;
  *)
    log "Usage: $0 [auto|all|zcode|hermes|claude|grok|openclaw|codex|gemini|chatgpt]"
    exit 2
    ;;
esac

log ""
log "ND30 Skill $VERSION deployment finished."
log "Canonical source: https://github.com/$REPO/tree/main/skills/$SKILL_NAME"
