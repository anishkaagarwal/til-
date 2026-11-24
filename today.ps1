# Start today's daily log:  ./today.ps1
# Creates daily/<yyyy-MM-dd>.md from daily/TEMPLATE.md and links it in the README.
# Paste the morning Slack brief's items into it, then tick them off during the day.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)

$date = Get-Date -Format 'yyyy-MM-dd'
$path = "daily/$date.md"
if (Test-Path $path) { Write-Host "Already exists: $path"; exit 0 }

$body = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'daily/TEMPLATE.md'), $utf8).Replace('{{DATE}}', $date)
[IO.File]::WriteAllText((Join-Path $PSScriptRoot $path), $body, $utf8)

$readmePath = Join-Path $PSScriptRoot 'README.md'
$readme = [IO.File]::ReadAllText($readmePath, $utf8)
$readme = $readme.Replace('<!-- daily:start -->', "<!-- daily:start -->`n- [$date]($path)")
[IO.File]::WriteAllText($readmePath, $readme, $utf8)

Write-Host "Created $path. Fill it from today's Slack brief, then:"
Write-Host "  git add -A; git commit -m `"Daily log $date`"; git push"
