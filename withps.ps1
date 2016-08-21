#Allow Scripts: Set-ExecutionPolicy Unrestricted -Scope CurrentUser
#DisallowScripts: Set-ExecutionPolicy Restricted -Scope CurrentUser
param (
    [switch]$help = $false,
    [switch]$version = $false,
    [switch]$update = $false,
    [switch]$install = $false,
    [switch]$delete = $false,
    [switch]$remove = $false
)
$progVersion = "0.0.2"
$progInstallFolder = "$env:APPDATA\withps"

$progName = $MyInvocation.MyCommand.Name
$progPath = $MyInvocation.MyCommand.Path
$progInstalled = $false
if ($progPath.StartsWith($progInstallFolder)) {
    $progInstalled = $true
}
$program = $args -join " "

function printHelp {
    Write-Output "Syntax: with [-h] [-v] [-u] [-i] [-d] [-r] program"
    Write-Output "-h, -help:    Display this message"
    Write-Output "-v, -version: Display the currently installed version of with"
    Write-Output "-u, -update:  Updates with"
    if (-Not $progInstalled) {
        Write-Output "-i, -install: Installs withPS in PATH"
        Write-Output "-d, -delete:  Delete file after install"
    } else {
        Write-Output "-r, -remove:  Completely removes with form the Computer"
    }    
}

function printVersion {
    Write-Output "PowerShell with $progVersion"
}

function update {
    Write-Output "Updating withPS $progVersion"
    New-Item $progInstallFolder -Force -itemtype directory | Out-Null
    Invoke-WebRequest https://raw.githubusercontent.com/Acader/withPS/master/withps.ps1 -OutFile "$progInstallFolder\withps.ps1"
    Invoke-WebRequest https://raw.githubusercontent.com/master/with.cmd -OutFile "$progInstallFolder\with.cmd"
    if (-not $progInstalled) {
        install $false    
    }
}

function install($copy = $true) {
    Write-Output "Installing withPS ..."
    New-Item $progInstallFolder -Force -itemtype directory | Out-Null
    Write-Output "Appdata dir created"
    if ($copy) {    
        Copy-Item $progName "$progInstallFolder\withps.ps1"
        Write-Output "$progName copyed to AppData as withps.ps1"
    }
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($oldPath -notlike "*$progInstallFolder*") {        
        $newPath = "$oldPath;$progInstallFolder"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Output "withPS added to the PATH"
    } else {
        Write-Output "withPS is already in the PATH"
    }
    if ($delete) {
        Remove-Item $progPath -Force
    }
    Write-Output "Installation finished"
}

function remove () {
    Write-Output "Removing withPS ..."
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($oldPath -like "*$progInstallFolder*") {        
        $newPath = $oldPath.Replace(";$progInstallFolder", "")
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Output "withPS removed from PATH"
    } else {
        Write-Output "withPS isn't in the PATH"
    }
    If (Test-Path $progInstallFolder){
        Remove-Item -Recurse -Force $progInstallFolder
    }

    Write-Output "withPS is not compleatly removed from you System"

}

function run() {
    $command = Read-Host $program
    if ($command.StartsWith(":")) {
        Invoke-Expression $command.Substring(1)        
    } elseif ($command.StartsWith("+")) {
        $temp = $command.Substring(1)
        if ($temp.Length -gt 0) {
            $program = "$program " + $temp    
        }        

    } elseif ($command.StartsWith("--") -and $command.Length -eq 2) {
        $program = ($program -split " ")[0]

    } elseif ($command.StartsWith("-") -and $command.Length -eq 1) {
        $temp = ($program -split " ")
        if ($temp.Length -gt 1) {
            $program = $temp[0..($temp.Length - 2)] -join " "
        }
        
    } else {
        Invoke-Expression "$program $command"
    }
    run
}

if ($update) {
    update
} elseif ($install -and -not $progInstalled) {
    install
} elseif ($remove -and $progInstalled) {
    remove
} else {
    if ($version) {
        printVersion
    }
    if ($help) {
        printHelp
    }
    if ($program) {
        if (Get-Command $program -errorAction SilentlyContinue)
        {
            run
        } else {
            echo "error: $program is not installed"
        }
    }

}


