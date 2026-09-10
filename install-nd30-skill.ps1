$ErrorActionPreference = 'Stop'
$SkillName = 'vietnam-government-document-nd30'
$RawUrl = "https://raw.githubusercontent.com/trunghieuvtth/agent-skills/main/skills/$SkillName/SKILL.md"
$Mode = if ($args.Count -gt 0) { $args[0].ToLower() } else { 'auto' }

function Install-HermesSkill {
    $dest = Join-Path $HOME ".hermes\skills\government\$SkillName"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Invoke-WebRequest -UseBasicParsing $RawUrl -OutFile (Join-Path $dest 'SKILL.md')
    Write-Host "[OK] Hermes: $dest\SKILL.md"
}

function Install-ZCodeSkill {
    $dest = Join-Path $HOME ".zcode\skills\$SkillName"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Invoke-WebRequest -UseBasicParsing $RawUrl -OutFile (Join-Path $dest 'SKILL.md')
    Write-Host "[OK] ZCode: $dest\SKILL.md"
    Write-Host "Open ZCode -> Settings -> Skills -> Refresh, then enable $SkillName."
}

switch ($Mode) {
    'hermes' { Install-HermesSkill }
    'zcode'  { Install-ZCodeSkill }
    'all'    { Install-HermesSkill; Install-ZCodeSkill }
    'auto' {
        $hermesDetected = (Get-Command hermes -ErrorAction SilentlyContinue) -or (Test-Path (Join-Path $HOME '.hermes'))
        $zcodeDetected = (Get-Command zcode -ErrorAction SilentlyContinue) -or (Test-Path (Join-Path $HOME '.zcode'))
        if ($hermesDetected) { Install-HermesSkill }
        if ($zcodeDetected) { Install-ZCodeSkill }
        if (-not $hermesDetected -and -not $zcodeDetected) {
            Write-Host 'No Hermes/ZCode installation detected. Installing both user-level skill directories.'
            Install-HermesSkill
            Install-ZCodeSkill
        }
    }
    default { throw 'Usage: install-nd30-skill.ps1 [auto|hermes|zcode|all]' }
}
Write-Host "Skill installed: $SkillName V3.3"
