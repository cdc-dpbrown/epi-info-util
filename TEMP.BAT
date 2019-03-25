CLS
@ECHO ON
COLOR 0E

SETLOCAL ENABLEDELAYEDEXPANSION


ECHO %CD%

SET batchRootDirectory=%CD%
SET requiredFilesDirectory="C:\requiredFiles (ei7)"
SET ei7=%batchRootDirectory%\Epi-Info-Community-Edition

RMDIR /S /Q  %ei7%\Build\release\Projects

COPY /Y %requiredFilesDirectory%\projectsRelease\Projects %ei7%\build\release\Projects

GOTO :EOF


for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "fullstamp=@%YYYY%-%MM%-%DD%@%HH%-%Min%-%Sec%"
echo fullstamp: "%fullstamp%

SET newName=%ei7%\Build\"Epi Info 7"%fullstamp%
XCOPY %ei7%\Build\"Epi Info 7" %newName% /I /E




GOTO :EOF












COPY /Y %requiredFilesDirectory%"\Launch Epi Info 7.exe" %ei7%"\build\Launch Epi Info 7.exe"
XCOPY %ei7%\Build\release %ei7%\Build\"Epi Info 7" /I /E






set FILETOZIP=%ei7%"\build\Launch Epi Info 7.exe"

set TEMPDIR=%batchRootDirectory%
rmdir %TEMPDIR%
mkdir %TEMPDIR%
xcopy /s %FILETOZIP% %TEMPDIR%

echo Set objArgs = WScript.Arguments > _zipIt.vbs
echo InputFolder = objArgs(0) >> _zipIt.vbs
echo ZipFile = objArgs(1) >> _zipIt.vbs
echo CreateObject("Scripting.FileSystemObject").CreateTextFile(ZipFile, True).Write "PK" ^& Chr(5) ^& Chr(6) ^& String(18, vbNullChar) >> _zipIt.vbs
echo Set objShell = CreateObject("Shell.Application") >> _zipIt.vbs
echo Set source = objShell.NameSpace(InputFolder).Items >> _zipIt.vbs
echo objShell.NameSpace(ZipFile).CopyHere(source) >> _zipIt.vbs
echo wScript.Sleep 2000 >> _zipIt.vbs

CScript  _zipIt.vbs  %TEMPDIR%  C:\someArchive.zip

pause

:: COPY /Y %requiredFilesDirectory%"\Launch Epi Info 7.exe" %batchRootDirectory%"\Epi-Info-Community-Edition\build\release\Launch Epi Info 7.exe"

::CALL code -n %requiredFilesDirectory%\Configuration_Static.cs %ei7%"\Epi Info 7.sln"
ENDLOCAL


:EOF