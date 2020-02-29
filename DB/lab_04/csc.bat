@echo off

echo Compiling CS file: %~1.cs...
C:\Windows\Microsoft.NET\Framework\v3.5\csc.exe /t:library /out:%~1.dll %~1.cs
pause
exit /B