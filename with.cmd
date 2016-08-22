@echo off
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0withps.ps1'" %*
