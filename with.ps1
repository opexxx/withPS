$version = "0.1"
$installFolder = "$env:APPDATA\withps"

function Write-Help {
    Write-Host "Syntax: with program"
    Write-Host "-h, -help:    Display this message"
    Write-Host "-v, -version: Display the currently installed version of withPS"
    Write-Host "-u, -update:  Updates withPS"
    Write-Host "-i, -install: Installs withPS in PATH"
    Write-Host "-r, -remove:  Completely removes withPS form the Computer"
    Write-Host "-g, -github:  Opens the withPS GitHub page"
}

function Write-Version {
    Write-Host "with for PowerShell $version"
}

function update {
    if (Test-Path $installFolder) {
        Write-Host "Updating withPS $version"
        (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/Acader/withPS/master/with.ps1", "$installFolder\with.ps1")
        (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/Acader/withPS/master/with.cmd", "$installFolder\with.cmd")
    } else {
        Write-Warning "withPS is not installed. To install it run 'with -i'"
    }
}

function install {
    Write-Host "Installing withPS ..."
    if (-not (Test-Path $installFolder)) {
        New-Item $installFolder -Force -itemtype directory | Out-Null
    }
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($oldPath -notlike "*$installFolder*") {        
        $newPath = "$oldPath;$installFolder"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    }
    update
    Write-Host "Installation finished"
}

function remove {
    Write-Host "Removing withPS ..."
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($oldPath -like "*$installFolder*") {        
        $newPath = $oldPath.Replace(";$installFolder", "")
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    }
    If (Test-Path $installFolder){
        Remove-Item -Recurse -Force $installFolder
    }
    Write-Host "withPS is now compleatly removed from you System"
}

function Test-Command ($com) {
    if (-not $com) {
        return $false
    }
    $progName = ($com -split " ")[0]
    if (Get-Command $progName -errorAction SilentlyContinue) {
        return $true
    }
    Write-Warning "'$progName' is not valid command"
    return $false
}

function run {
    Write-Host -NoNewline "$(Get-Location) $prefix> "
    $command = Read-Host
    switch -wildcard ($command) {
        "[:!]*" {
            $command = $command.Substring(1)
            if ($command -eq "exit" -or (Test-Command $command)) {
                Invoke-Expression $command
            }
        }
        "+*" {
            $temp = $command.Substring(1)
            if ($temp.Length -gt 0) {
                $prefix = "$prefix $temp"    
            }
        }
        "-" {
            $temp = ($prefix -split " ")
            if ($temp.Length -gt 1) {
                $prefix = $temp[0..($temp.Length - 2)] -join " "
            }
        }
        "--" {
            $prefix = ($prefix -split " ")[0]
        }
        default {
            Invoke-Expression "$prefix $command"
        }
    }
    run
}

if (-not $MyInvocation.MyCommand.Path) {
    install
    break
}
$prefix = $args -join " "

switch -wildcard ($args[0]) {
    "-h*" { Write-Help }
    "-v*" { Write-Version }
    "-u*" { update }
    "-i*" { install }
    "-r*" { remove }
    "-g*" { Start-Process "https://github.com/Acader/withPS" }
    Default {
        if ($prefix) {
            if(Test-Command $prefix) {
                run
            } 
        } else {
            Write-Help
        }
    }
}
