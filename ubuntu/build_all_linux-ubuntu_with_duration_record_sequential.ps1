# ------------------------------------------------------------------------------
# Name:           build_all_windows_with_duration_record_sequential.ps1
# Description:    Sequential build all Linux Ubuntu with duration record
# Code revision:  Andrey Eremchuk, https://github.com/IVAndr0n/
# ------------------------------------------------------------------------------

$host.ui.RawUI.WindowTitle = 'Sequential build all Linux Ubuntu with duration record'

$logsDirectory = Join-Path -Path $PSScriptRoot -ChildPath 'manifests'
if(-not (Test-Path $logsDirectory)) {
    mkdir $logsDirectory
}
$packerFiles = Get-ChildItem -Path $PSScriptRoot -Filter *.pkrvar.hcl
foreach ($file in $packerFiles) {
    Set-Location $PSScriptRoot
    $logFileName = "packerlog-$($file.BaseName).txt"
    $durationFileName = "duration-$($file.BaseName).txt"
    $env:PACKER_LOG=1
    $env:PACKER_LOG_PATH="$logsDirectory\$logFileName"
    $env:PACKER_CACHE_DIR="$logsDirectory\cache"
    $env:PACKER_PLUGIN_CACHE_DIR="$logsDirectory\plugin-cache"
    & packer build -force -var-file="$PSScriptRoot\$file" "$PSScriptRoot\."
    $duration = Get-Content $env:PACKER_LOG_PATH | Select-String -Pattern "Wait completed after"
    $duration | Out-File "$logsDirectory\$durationFileName" -Append
}