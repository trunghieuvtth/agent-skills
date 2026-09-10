#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="vietnam-government-document-nd30"
RAW_URL="https://raw.githubusercontent.com/trunghieuvtth/agent-skills/main/skills/${SKILL_NAME}/SKILL.md"
MODE="${1:-auto}"

install_hermes() {
  mkdir -p "$HOME/.hermes/skills/government/${SKILL_NAME}"
  curl -fsSL "$RAW_URL" -o "$HOME/.hermes/skills/government/${SKILL_NAME}/SKILL.md"
  echo "[OK] Hermes: $HOME/.hermes/skills/government/${SKILL_NAME}/SKILL.md"
  if command -v hermes >/dev/null 2>&1; then
    hermes skills list | grep -i "$SKILL_NAME" || true
  fi
}

install_zcode() {
  mkdir -p "$HOME/.zcode/skills/${SKILL_NAME}"
  curl -fsSL "$RAW_URL" -o "$HOME/.zcode/skills/${SKILL_NAME}/SKILL.md"
  echo "[OK] ZCode: $HOME/.zcode/skills/${SKILL_NAME}/SKILL.md"
  echo "Open ZCode -> Settings -> Skills -> Refresh, then enable ${SKILL_NAME}."
}

case "$MODE" in
  hermes) install_hermes ;;
  zcode) install_zcode ;;
  all) install_hermes; install_zcode ;;
  auto)
    FOUND=0
    if command -v hermes >/dev/null 2>&1 || [ -d "$HOME/.hermes" ]; then install_hermes; FOUND=1; fi
    if command -v zcode >/dev/null 2>&1 || [ -d "$HOME/.zcode" ]; then install_zcode; FOUND=1; fi
    if [ "$FOUND" -eq 0 ]; then
      echo "No Hermes/ZCode installation detected. Installing both user-level skill directories."
      install_hermes
      install_zcode
    fi
    ;;
  *) echo "Usage: $0 [auto|hermes|zcode|all]"; exit 2 ;;
esac

echo "Skill installed: ${SKILL_NAME} V3.3"
