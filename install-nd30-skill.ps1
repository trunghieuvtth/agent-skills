$ErrorActionPreference = 'Stop'
$SkillName = 'vietnam-government-document-nd30'
$Version = '3.3.1'
$Repo = 'trunghieuvtth/agent-skills'
$BaseRaw = "https://raw.githubusercontent.com/$Repo/main/skills/$SkillName"
$RawUrl = "$BaseRaw/SKILL.md"
$RepoUrl = "https://github.com/$Repo.git"
$Mode = if ($args.Count -gt 0) { $args[0].ToLower() } else { 'auto' }

$TemplateFiles = @(
  'README.md','shared_layout.yaml','template_registry.yaml','generic_named_document.yaml',
  'cong_van.yaml','quyet_dinh.yaml','ke_hoach.yaml','bao_cao.yaml','to_trinh.yaml','thong_bao.yaml','giay_moi.yaml'
)

function Has-Cmd($name) { return [bool](Get-Command $name -ErrorAction SilentlyContinue) }
function Download-Bundle($dest) {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    $templates = Join-Path $dest 'templates'
    New-Item -ItemType Directory -Force -Path $templates | Out-Null
    $skillOut = Join-Path $dest 'SKILL.md'
    Invoke-WebRequest -UseBasicParsing $RawUrl -OutFile $skillOut
    $txt = Get-Content $skillOut -Raw
    if ($txt -notmatch '(?m)^name:\s*vietnam-government-document-nd30\s*$') { throw 'Invalid skill name/frontmatter' }
    if ($txt -notmatch '3\.3\.1') { throw 'Unexpected skill version' }
    foreach ($f in $TemplateFiles) {
        Invoke-WebRequest -UseBasicParsing "$BaseRaw/templates/$f" -OutFile (Join-Path $templates $f)
    }
    if (-not (Test-Path (Join-Path $templates 'template_registry.yaml'))) { throw 'Template registry missing' }
    return $dest
}

function Install-ZCode { $p=Download-Bundle (Join-Path $HOME ".zcode\skills\$SkillName"); Write-Host "[OK] ZCode       -> $p" }
function Install-Hermes { $p=Download-Bundle (Join-Path $HOME ".hermes\skills\government\$SkillName"); Write-Host "[OK] Hermes      -> $p" }
function Install-Claude { $p=Download-Bundle (Join-Path $HOME ".claude\skills\$SkillName"); Write-Host "[OK] Claude Code -> $p" }
function Install-Grok { $p=Download-Bundle (Join-Path $HOME ".grok\skills\$SkillName"); Write-Host "[OK] Grok CLI    -> $p" }
function Install-OpenClaw { $p=Download-Bundle (Join-Path $HOME ".openclaw\skills\$SkillName"); Write-Host "[OK] OpenClaw    -> $p" }
function Install-Codex {
    $homeDir = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
    $p=Download-Bundle (Join-Path $homeDir "skills\$SkillName"); Write-Host "[OK] Codex       -> $p"
}
function Install-Gemini {
    if (Has-Cmd 'gemini') {
        try { gemini skills install $RepoUrl --path "skills/$SkillName" --scope user --consent | Out-Null; Write-Host '[OK] Gemini CLI  -> native repository installer'; return } catch {}
    }
    $p=Download-Bundle (Join-Path $HOME ".gemini\skills\$SkillName"); Write-Host "[OK] Gemini CLI  -> $p (fallback)"
}
function Show-ChatGPTNote {
    Write-Host '[INFO] ChatGPT web/app cannot be modified by a local shell installer.'
    Write-Host '       Import/upload the complete skill folder/package in the ChatGPT Skills/Workspace UI when available.'
    Write-Host "       Canonical source: https://github.com/$Repo/tree/main/skills/$SkillName"
}
function Install-All { Install-ZCode; Install-Hermes; Install-Claude; Install-Grok; Install-OpenClaw; Install-Codex; Install-Gemini; Show-ChatGPTNote }
function Install-Auto {
    $found=$false
    if ((Has-Cmd 'zcode') -or (Test-Path (Join-Path $HOME '.zcode'))) { Install-ZCode; $found=$true }
    if ((Has-Cmd 'hermes') -or (Test-Path (Join-Path $HOME '.hermes'))) { Install-Hermes; $found=$true }
    if ((Has-Cmd 'claude') -or (Test-Path (Join-Path $HOME '.claude'))) { Install-Claude; $found=$true }
    if ((Has-Cmd 'grok') -or (Test-Path (Join-Path $HOME '.grok'))) { Install-Grok; $found=$true }
    if ((Has-Cmd 'openclaw') -or (Test-Path (Join-Path $HOME '.openclaw'))) { Install-OpenClaw; $found=$true }
    if ((Has-Cmd 'codex') -or $env:CODEX_HOME -or (Test-Path (Join-Path $HOME '.codex'))) { Install-Codex; $found=$true }
    if ((Has-Cmd 'gemini') -or (Test-Path (Join-Path $HOME '.gemini'))) { Install-Gemini; $found=$true }
    if (Test-Path (Join-Path $HOME '.agents\skills')) { $p=Download-Bundle (Join-Path $HOME ".agents\skills\$SkillName"); Write-Host "[OK] AgentSkills -> $p"; $found=$true }
    if (-not $found) { Write-Host 'No supported local AI runtime detected. Use mode all to provision all supported local skill locations.' }
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
Write-Host 'Installed bundle includes SKILL.md + templates/.'
Write-Host "Canonical source: https://github.com/$Repo/tree/main/skills/$SkillName"
