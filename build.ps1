$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$aspNetCompiler = Join-Path $env:WINDIR "Microsoft.NET\Framework\v4.0.30319\aspnet_compiler.exe"
$msbuild = Join-Path $env:WINDIR "Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
$outputRoot = Join-Path $projectRoot "build_output"

if (-not (Test-Path $aspNetCompiler)) {
    throw "aspnet_compiler.exe was not found at '$aspNetCompiler'."
}

Write-Host "Project root: $projectRoot"
Write-Host "aspnet_compiler: $aspNetCompiler"
Write-Host "MSBuild: $msbuild"
Write-Host "Output: $outputRoot"

if (Test-Path $outputRoot) {
    Get-ChildItem -LiteralPath $outputRoot -Force | Remove-Item -Recurse -Force
} else {
    New-Item -ItemType Directory -Path $outputRoot | Out-Null
}

& $aspNetCompiler -p $projectRoot -v / -f $outputRoot

if ($LASTEXITCODE -ne 0) {
    throw "aspnet_compiler failed with exit code $LASTEXITCODE."
}

Write-Host "Precompile completed successfully."
