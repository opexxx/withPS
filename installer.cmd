@echo off
echo withPS installation ...
powershell -nop -c "Invoke-WebRequest https://raw.githubusercontent.com/Acader/withPS/master/withps.ps1 -OutFile '.\withps.ps1'"
powershell -ExecutionPolicy Bypass -File ".\withps.ps1" -Command -u -d