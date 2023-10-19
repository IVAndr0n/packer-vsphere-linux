# ------------------------------------------------------------------------------
# Name:           build_all_windows_with_duration_record_parallel.ps1
# Description:    Parallel build all Linux Ubuntu with duration record
# Code revision:  Andrey Eremchuk, https://github.com/IVAndr0n/
# ------------------------------------------------------------------------------

$host.ui.RawUI.WindowTitle = 'Parallel build all Linux Ubuntu with duration record'

$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogsDirectory = Join-Path -Path $ScriptDirectory -ChildPath 'manifests'

if (-not (Test-Path $LogsDirectory)) {
    mkdir $LogsDirectory
}

$PackerFiles = Get-ChildItem -Path $ScriptDirectory -Filter *.pkrvar.hcl

$Jobs = @()
foreach ($File in $PackerFiles) {
    $LogFileName = "packerlog-$($File.BaseName).txt"
    $durationFileName = "duration-$($File.BaseName).txt"
    $Env:PACKER_LOG=1
    $Env:PACKER_LOG_PATH=Join-Path -Path $LogsDirectory -ChildPath $LogFileName
    $Env:PACKER_CACHE_DIR=Join-Path -Path $LogsDirectory -ChildPath 'cache'
    $Env:PACKER_PLUGIN_CACHE_DIR=Join-Path -Path $LogsDirectory -ChildPath 'plugin-cache'
    
    $Job = Start-Job -ScriptBlock {
        param($ScriptDirectory, $File, $LogFileName, $durationFileName, $LogsDirectory)
        Set-Location $ScriptDirectory
        & packer build -force -var-file="$ScriptDirectory\$File" "$ScriptDirectory\."
        $Duration = Get-Content $Env:PACKER_LOG_PATH | Select-String -Pattern "Wait completed after"
        $Duration | Out-File -FilePath (Join-Path -Path $LogsDirectory -ChildPath $durationFileName) -Force
    } -ArgumentList $ScriptDirectory, $File, $LogFileName, $durationFileName, $LogsDirectory
    $Jobs += $Job
}

$Jobs | Wait-Job | Receive-Job