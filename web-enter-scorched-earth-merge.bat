CLS
@ECHO OFF
COLOR 0A


ECHO :: ===============================================================
ECHO :: SET LOCAL VARIABLES
ECHO :: ===============================================================
SETLOCAL ENABLEDELAYEDEXPANSION
SET buildEXE="C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe"
SET batchRootDirectory=%CD%
SET privateBuildFiles=C:\epi-info-private-build-files
SET webEnterMergePath=%batchRootDirectory%\Epi-Info-Web-Enter-Merge
SET webSurvey=%batchRootDirectory%\Epi-Info-Web-Survey
SET KEY_QUIET=Q
SET KEY_HELP=/?
SET ARGS=%1
IF "%ARGS%" EQU "" SET ARGS=1
SET QUIET=FALSE
SET HELP=FALSE
IF NOT "x!ARGS:%KEY_QUIET%=!"=="x%ARGS%" SET QUIET=TRUE
IF NOT "x!ARGS:%KEY_HELP%=!"=="x%ARGS%" GOTO :HELP
ECHO ARGS=%ARGS%
ECHO QUIET: %QUIET%
ECHO HELP: %HELP%
ECHO batchRootDirectory: %batchRootDirectory%
ECHO webEnterMergePath:  %webEnterMergePath%
ECHO webSurvey: %webSurvey%


ECHO :: ===============================================================
ECHO :: DELETE WEB ENTER MERGE FOLDER
ECHO :: ===============================================================
IF %QUIET%==TRUE GOTO :DELETEEPIINFOFOLDER
:ASK_SKIP_DELETE
SET /P d=DELETE WEB SURVEY FOLDER [Y/N]?
IF /I "%d%" EQU "Y" GOTO :DELETEEPIINFOFOLDER
IF /I "%d%" EQU "N" GOTO :SKIP_DELETE
GOTO :ASK_SKIP_DELETE
:DELETEEPIINFOFOLDER

IF EXIST  %webEnterMergePath% (
    ECHO.
    ECHO Deleting %webEnterMergePath% directory
) 

IF EXIST  %webEnterMergePath% (
    RMDIR /S /Q  %webEnterMergePath%
)

IF EXIST  %webEnterMergePath% (
    COLOR 0A
    ECHO  %webEnterMergePath% - still there - try restartExplorer.bat
    EXIT /B
) ELSE (
    COLOR
    ECHO  %webEnterMergePath% - gone
)
:SKIP_DELETE


ECHO :: ===============================================================
ECHO :: GET SOURCE - GIT CLONE WEB ENTER REPO INTO WEB ENTER MERGE
ECHO :: ===============================================================
IF %QUIET%==TRUE GOTO:GET_SOURCE
IF /I "%d%" EQU "Y" GOTO :GET_SOURCE
:ASK_GET_SOURCE
SET /P o=OVERWRITE (GET) FROM GITHUB [Y/N]?
IF /I "%o%" EQU "Y" GOTO :GET_SOURCE
IF /I "%o%" EQU "N" GOTO :SKIP_GET_SOURCE
GOTO :ASK_GET_SOURCE
:GET_SOURCE
@ECHO ON
git clone https://github.com/Epi-Info/Epi-Info-Cloud-Data-Capture.git
@ECHO OFF
::CD  webEnterMergePath%
::git reset --hard c5baca6a6c08f2168bc28d00f7db0e2ce104fd24
:SKIP_GET_SOURCE



ECHO :: ===============================================================
ECHO :: COPY WEB SURVEY FILES TO WEB ENTER FOLDER
ECHO :: ===============================================================
@ECHO ON
XCOPY %webSurvey% %webEnterMergePath% /I /E /Q
@ECHO OFF

GIT DIFF








ECHO :: ===============================================================
ECHO :: OPEN WINDOWS EXPLORER IN WEB SURVEY DIRECTORY
ECHO :: ===============================================================
@ECHO ON
::EXPLORER  webEnterMergePath%
@ECHO OFF
:: ===============================================================

ECHO.
ECHO :: ===============================================================
ECHO :: COPY WEB CONFIG
ECHO :: ===============================================================
ECHO.
@ECHO ON
COPY /Y %privateBuildFiles%\cloud-data-capture\Web.config  webEnterMergePath%\Epi.Web\Web.config
@ECHO OFF





GOTO :EOF






ECHO :: ===============================================================
ECHO :: OPEN SOLUTION IN VISUAL STUDIO
ECHO :: ===============================================================
ECHO.
@ECHO ON
CD %batchRootDirectory%
CALL nuget restore  webEnterMergePath%"\Epi Info Web.sln"
@ECHO OFF
ECHO.
ECHO.
ECHO     [ STARTING BUILD ] PLEASE WAIT ... ( ~30 SECONDS )
ECHO.
ECHO.
CD  webEnterMergePath%
:: CALL %buildEXE% "Epi Info Web.sln" /m /p:Configuration=Release /p:Platform=x86 /clp:Summary=true;ErrorsOnly
@ECHO OFF
:: ===============================================================

ECHO :: ===============================================================
ECHO :: OPEN SOLUTION IN VISUAL STUDIO
ECHO :: ===============================================================
@ECHO ON
CD  webEnterMergePath%
CALL "Epi Info Web.sln"
@ECHO OFF
ECHO :: ===============================================================


ENDLOCAL
GOTO :EOF

:HELP
ECHO :: ===============================================================
ECHO :: HELP
ECHO :: ===============================================================
ECHO Q   Quiet mode
GOTO :EOF
:: ===============================================================

:EOF