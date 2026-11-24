# Create a new TIL note:  ./new.ps1 <topic> "<title>"
# Topics: agents, rag, voice-ai, llmops, python, cloud, dsa
param(
  [Parameter(Mandatory = $true)][string]$Topic,
  [Parameter(Mandatory = $true)][string]$Title
)
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$date = Get-Date -Format 'yyyy-MM-dd'
$slug = ($Title.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')
New-Item -ItemType Directory -Force $Topic | Out-Null
$path = "$Topic/$date-$slug.md"
if (Test-Path $path) { Write-Host "Already exists: $path"; exit 1 }

$utf8 = New-Object System.Text.UTF8Encoding($false)
$body = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'TEMPLATE.md'), $utf8).Replace('{{TITLE}}', $Title).Replace('{{DATE}}', $date).Replace('{{TOPIC}}', $Topic)
[IO.File]::WriteAllText((Join-Path $PSScriptRoot $path), $body, $utf8)

# Add to the README list, newest first
$readmePath = Join-Path $PSScriptRoot 'README.md'
$readme = [IO.File]::ReadAllText($readmePath, $utf8)
$entry = "- $date - [$Title]($path) - ``$Topic``"
$readme = $readme.Replace('<!-- notes:start -->', "<!-- notes:start -->`n$entry")
[IO.File]::WriteAllText($readmePath, $readme, $utf8)

Write-Host "Created $path. Fill it in, then:"
Write-Host "  git add -A; git commit -m `"TIL: $Title`"; git push"
