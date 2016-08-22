param (
    [switch]$help = $false,
    [switch]$version = $false,
    [switch]$update = $false,
    [switch]$install = $false,
    [switch]$remove = $false
)
$progVersion = "0.0.3"
$progInstallFolder = "$env:APPDATA\withps"
$progPath = $MyInvocation.MyCommand.Path
$progInstalled = $false
if (-not $progPath) {
    $install = $true
} elseif ($progPath.StartsWith($progInstallFolder)) {
    $progInstalled = $true
}
$program = $args -join " "

function printHelp {
    Write-Output "Syntax: with [-h] [-v] [-u] [-i] [-r] program"
    Write-Output "-h, -help:    Display this message"
    Write-Output "-v, -version: Display the currently installed version of with"
    Write-Output "-u, -update:  Updates with"
    if (-Not $progInstalled) {
        Write-Output "-i, -install: Installs withPS in PATH"
    } else {
        Write-Output "-r, -remove:  Completely removes with form the Computer"
    }    
}

function printVersion {
    Write-Output "PowerShell with $progVersion"
}

function update {
    Write-Output "Updating withPS $progVersion"
    Invoke-WebRequest https://raw.githubusercontent.com/Acader/withPS/master/withps.ps1 -OutFile "$progInstallFolder\withps.ps1"
    Invoke-WebRequest https://raw.githubusercontent.com/Acader/withPS/master/with.cmd -OutFile "$progInstallFolder\with.cmd"
}

function install {
    Write-Output "Installing withPS ..."
    if (-not (Test-Path $progInstallFolder)) {
        New-Item $progInstallFolder -Force -itemtype directory | Out-Null    
    }
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($oldPath -notlike "*$progInstallFolder*") {        
        $newPath = "$oldPath;$progInstallFolder"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    }
    update
    Write-Output "Installation finished"
}

function remove {
    Write-Output "Removing withPS ..."
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($oldPath -like "*$progInstallFolder*") {        
        $newPath = $oldPath.Replace(";$progInstallFolder", "")
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    }
    If (Test-Path $progInstallFolder){
        Remove-Item -Recurse -Force $progInstallFolder
    }

    Write-Output "withPS is now compleatly removed from you System"

}

function run {
    Write-Host -NoNewline "$program`: "
    $command = Read-Host
    switch -wildcard ($command) {
        "[:!]*" {
            Invoke-Expression $command.Substring(1)
        }
        "+*" {
            $temp = $command.Substring(1)
            if ($temp.Length -gt 0) {
                $program = "$program " + $temp    
            }        
        }
        "-" {
            $temp = ($program -split " ")
            if ($temp.Length -gt 1) {
                $program = $temp[0..($temp.Length - 2)] -join " "
            }
        }
        "--" {
            $program = ($program -split " ")[0]
        }
        default {
            Invoke-Expression "$program $command"
        }
    }
    run
}

if (-not ($progInstalled -or $install)) {
    Write-Output "It seams 'with' is not installed run 'with -i' to install it"
}

if ($install -and -not $progInstalled) {
    install
} elseif ($update -and $progInstalled) {
    update
} elseif ($remove -and $progInstalled) {
    remove
} elseif ($version) {
    printVersion
} elseif ($help) {
    printHelp
} elseif ($program) {
    $programName = ($program -split " ")[0]
    if (Get-Command $programName -errorAction SilentlyContinue) {
        run
    } else {
        Write-Output "error: '$programName' is not installed"
    }
}
