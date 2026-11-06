$ErrorActionPreference = 'Stop'
$engine = 'C:\towerdefense\tools\godot\Godot_v4.7.2-stable_win64_console.exe'
$checks = @(
    @('res://tools/test_intro.gd'),
    @('res://tools/test_intro.gd', '--', '--c4'),
    @('res://tools/test_stealth_route.gd'),
    @('res://tools/test_intro_controls.gd')
)
New-Item -ItemType Directory -Force (Join-Path $PSScriptRoot 'tmp') | Out-Null
$index = 0
foreach ($check in $checks) {
    $index += 1
    $arguments = @('--headless', '--path', $PSScriptRoot, '--fixed-fps', '60', '--script') + $check
    $result = & $engine @arguments 2>&1
    $exitCode = $LASTEXITCODE
    $result | Set-Content (Join-Path $PSScriptRoot "tmp/check-$index.log")
    if ($exitCode -ne 0 -or ($result -match 'SCRIPT ERROR:|ERROR:|FAIL:')) {
        $result | Write-Output
        throw "Intro check $index failed."
    }
    $result | Select-String 'RESULT|failures='
}
Write-Output 'All intro checks passed; no engine/script errors.'
