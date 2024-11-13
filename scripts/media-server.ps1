param (
    [string]$command
)

$packageDir = "./bin"
$mediaMtxExecutable = "$packageDir/mediamtx.exe"
$mediaMtxConfig = "$packageDir/mediamtx.yml"
$downloadUrl = "https://github.com/bluenviron/mediamtx/releases/download/v1.9.3/mediamtx_v1.9.3_windows_amd64.zip"

function MediaMtxExecutable {
    Write-Host $mediaMtxExecutable
    $command = Get-Command "mediamtx" -ErrorAction SilentlyContinue
    if ($command) {
        Write-Host "mediamtx found in PATH at $($command.Source)"
        return $command.Source
    }
    
    if (Test-Path -Path $mediaMtxExecutable) {
        Write-Host "mediamtx found locally at $mediaMtxExecutable"
        return $mediaMtxExecutable
    }

    return $null
}

function Initialize-MediaServer {
    $executable = MediaMtxExecutable
    if ($executable) {
        Write-Host "mediamtx is already installed at $executable."
        return
    }

    if (!(Test-Path -Path $mediaMtxPath)) {
        New-Item -ItemType Directory -Path $mediaMtxPath -Force
    }

    $zipFilePath = "$mediaMtxPath\mediamtx.zip"
    Write-Host "Downloading mediamtx from $downloadUrl..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFilePath

    Write-Host "Extracting mediamtx to $mediaMtxPath..."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFilePath, $mediaMtxPath)

    Remove-Item -Path $zipFilePath -Force

    Write-Host "mediamtx has been installed successfully at $mediaMtxExecutable."
}

function Run-MediaServer {
    $executable = MediaMtxExecutable
    if (-not $executable) {
        Write-Host "mediamtx is not installed. Run 'media-server init' first."
        return
    }

    Write-Host "Running mediamtx with configuration at $mediaMtxConfig..."
    & $executable $mediaMtxConfig
}

switch ($command) {
    "init" { Initialize-MediaServer }
    "run" { Run-MediaServer }
    default { Write-Host "Usage: media-server.ps1 <init|run>" }
}
