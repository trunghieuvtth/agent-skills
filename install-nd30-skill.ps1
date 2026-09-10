$ErrorActionPreference = 'Stop'
$SkillName = 'vietnam-government-document-nd30'
$Version = '3.3.0'
$Repo = 'trunghieuvtth/agent-skills'
$RawUrl = "https://raw.githubusercontent.com/$Repo/main/skills/$SkillName/SKILL.md"
$RepoUrl = "https://github.com/$Repo.git"
$Mode = if ($args.Count -gt 0) { $args[0].ToLower() } else { 'auto' }

function Has-Cmd($name) { return [bool](Get-Command $name -ErrorAction SilentlyContinue) }
function Download-Skill($dest) {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    $out = Join-Path $dest 'SKILL.md'
    Invoke-WebRequest -UseBasicParsing $RawUrl -OutFile $out
    $txt = Get-Content $out -Raw
    if ($txt -notmatch '(?m)^name:\s*vietnam-government-document-nd30\s*$') { throw 'Invalid skill name/frontmatter' }
    if ($txt -notmatch '3\.3\.0') { throw 'Unexpected skill version' }
    return $out
}
function Install-ZCode { $p=Download-Skill (Join-Path $HOME ".zcode\skills\$SkillName"); Write-Host "[OK] ZCode      -> $p" }
function Install-Hermes {
    if (Has-Cmd 'hermes') {
        try { hermes skills install $RawUrl --now | Out-Null; Write-Host '[OK] Hermes     -> native installer'; return } catch {}
    }
    $p=Download-Skill (Join-Path $HOME ".hermes\skills\government\$SkillName"); Write-Host "[OK] Hermes     -> $p"
}
function Install-Claude { $p=Download-Skill (Join-Path $HOME ".claude\skills\$SkillName"); Write-Host "[OK] Claude Code -> $p" }
function Install-Grok { $p=Download-Skill (Join-Path $HOME ".grok\skills\$SkillName"); Write-Host "[OK] Grok CLI    -> $p" }
function Install-OpenClaw { $p=Download-Skill (Join-Path $HOME ".openclaw\skills\$SkillName"); Write-Host "[OK] OpenClaw    -> $p" }
function Install-Codex {
    $homeDir = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
    $p=Download-Skill (Join-Path $homeDir "skills\$SkillName"); Write-Host "[OK] Codex       -> $p"
}
function Install-Gemini {
    if (Has-Cmd 'gemini') {
        try { gemini skills install $RepoUrl --path "skills/$SkillName" --scope user --consent | Out-Null; Write-Host '[OK] Gemini CLI  -> native installer'; return } catch {}
    }
    $p=Download-Skill (Join-Path $HOME ".gemini\skills\$SkillName"); Write-Host "[OK] Gemini CLI  -> $p (fallback)"
}
function Show-ChatGPTNote {
    Write-Host '[INFO] ChatGPT web/app: shell install is not available.'
    Write-Host '       Use Plugins -> Skills -> Create -> Upload from computer on an eligible account.'
    Write-Host "       Source: $RawUrl"
}
function Install-All {
    Install-ZCode; Install-Hermes; Install-Claude; Install-Grok; Install-OpenClaw; Install-Codex; Install-Gemini; Show-ChatGPTNote
}
function Install-Auto {
    $found=$false
    if ((Has-Cmd 'zcode') -or (Test-Path (Join-Path $HOME '.zcode'))) { Install-ZCode; $found=$true }
    if ((Has-Cmd 'hermes') -or (Test-Path (Join-Path $HOME '.hermes'))) { Install-Hermes; $found=$true }
    if ((Has-Cmd 'claude') -or (Test-Path (Join-Path $HOME '.claude'))) { Install-Claude; $found=$true }
    if ((Has-Cmd 'grok') -or (Test-Path (Join-Path $HOME '.grok'))) { Install-Grok; $found=$true }
    if ((Has-Cmd 'openclaw') -or (Test-Path (Join-Path $HOME '.openclaw'))) { Install-OpenClaw; $found=$true }
    if ((Has-Cmd 'codex') -or $env:CODEX_HOME -or (Test-Path (Join-Path $HOME '.codex'))) { Install-Codex; $found=$true }
    if ((Has-Cmd 'gemini') -or (Test-Path (Join-Path $HOME '.gemini'))) { Install-Gemini; $found=$true }
    if (Test-Path (Join-Path $HOME '.agents\skills')) {
        $p=Download-Skill (Join-Path $HOME ".agents\skills\$SkillName"); Write-Host "[OK] AgentSkills -> $p"; $found=$true
    }
    if (-not $found) { Write-Host 'No supported local AI runtime detected. Use mode all to provision all local skill locations.' }
    Show-ChatGPTNote
}

switch ($Mode) {
    'auto' { Install-Auto }
    'all' { Install-All }
    'zcode' { Install-ZCode }
    'hermes' { Install-Hermes }
    'claude' { Install-Claude }
    'claude-code' { Install-Claude }
    'grok' { Install-Grok }
    'grok-cli' { Install-Grok }
    'openclaw' { Install-OpenClaw }
    'codex' { Install-Codex }
    'gemini' { Install-Gemini }
    'germini' { Install-Gemini }
    'chatgpt' { Show-ChatGPTNote }
    default { throw 'Usage: install-nd30-skill.ps1 [auto|all|zcode|hermes|claude|grok|openclaw|codex|gemini|chatgpt]' }
}
Write-Host "ND30 Skill $Version deployment finished."
Write-Host "Canonical source: https://github.com/$Repo/tree/main/skills/$SkillName"
