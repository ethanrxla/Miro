$ErrorActionPreference = 'Stop'
$engine = 'C:\towerdefense\tools\godot\Godot_v4.7.2-stable_win64_console.exe'
$outputDirectory = Join-Path $PSScriptRoot 'build/windows'
New-Item -ItemType Directory -Force $outputDirectory | Out-Null
& $engine --headless --path $PSScriptRoot --export-release 'Windows Desktop' (Join-Path $outputDirectory 'Miro.exe')
if ($LASTEXITCODE -ne 0) { throw 'Godot Windows export failed.' }
Write-Output "Windows build: $outputDirectory\Miro.exe"
