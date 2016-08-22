$version = "0.0.4"
$installFolder = "$env:APPDATA\withps"

function Print-Help {
    Write-Host "Syntax: with program"
    Write-Host "-h, -help:    Display this message"
    Write-Host "-v, -version: Display the currently installed version of with"
    Write-Host "-u, -update:  Updates with"
    Write-Host "-i, -install: Installs withPS in PATH"
    Write-Host "-r, -remove:  Completely removes with form the Computer"
    Write-Host "-g, -github:  Opens the withPS GitHub page"
}

function Print-Version {
    Write-Host "with for PowerShell $version"
}

function update {
    if (Test-Path $installFolder) {
        Write-Host "Updating withPS $version"
        (New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/Acader/withPS/master/withps.ps1", "$installFolder\withps.ps1")
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
    Write-Host -NoNewline "$program`> "
    $command = Read-Host
    switch -wildcard ($command) {
        "[:!]*" {
            $command = $command.Substring(1)
            if (Test-Command $command) {
                Invoke-Expression $command
            }
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

if (-not $MyInvocation.MyCommand.Path) {
    install
    exit
}
$program = $args -join " "

switch -wildcard ($args[0]) {
    "-h*" { Print-Help }
    "-v*" { Print-Version }
    "-u*" { update }
    "-i*" { install }
    "-r*" { remove }
    "-g*" { Start-Process "https://github.com/Acader/withPS" }
    Default {
        if ($program) {
            if(Test-Command $program) {
                run
            } 
        } else {
            Print-Help
        }
    }
}
