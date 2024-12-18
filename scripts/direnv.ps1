param (
    [string]$command
)

$packagesDir = "./packages"
$direnvExecutable = "$packagesDir/direnv.exe"
$downloadUrl = "https://github.com/direnv/direnv/releases/download/v2.35.0/direnv.windows-amd64.exe"

function DirenvExecutable {
    $command = Get-Command "direnv" -ErrorAction SilentlyContinue
    if ($command) {
        Write-Host "direnv found in PATH at $($command.Source)"
        return $command.Source
    }
    
    if (Test-Path -Path $direnvExecutable) {
        Write-Host "direnv found locally at $direnvExecutable"
        return $direnvExecutable
    }

    return $null
}

function Install-Direnv {
    $executable = DirenvExecutable
    if ($executable) {
        Write-Host "direnv is already installed at $executable."
        return
    }

    if (!(Test-Path -Path $packagesDir)) {
        New-Item -ItemType Directory -Path $packagesDir -Force
    }

    Write-Host "Downloading direnv from $downloadUrl..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $direnvExecutable

    Write-Host "direnv has been installed successfully at $direnvExecutable."
}

function Load-Direnv {
    $executable = DirenvExecutable
    if (-not $executable) {
        Write-Host "direnv is not installed. Run 'direnv.ps1 init' first."
        return
    }

    Invoke-Expression "$(direnv hook pwsh)"
}

switch ($command) {
    "install" { Install-Direnv }
    "load" { Load-Direnv }
    default { Write-Host "Usage: direnv.ps1 <install|load>" }
}
