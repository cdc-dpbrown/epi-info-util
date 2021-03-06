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

IF EXIST  "%webEnterMergePath%" (
    ECHO Deleting %webEnterMergePath% directory
) 

IF EXIST "%webEnterMergePath%" (
    RMDIR /S /Q "%webEnterMergePath%"
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
git clone https://github.com/Epi-Info/Epi-Info-Cloud-Data-Capture.git Epi-Info-Web-Enter-Merge
@ECHO OFF
::CD  webEnterMergePath%
::git reset --hard c5baca6a6c08f2168bc28d00f7db0e2ce104fd24
:SKIP_GET_SOURCE


ECHO :: ===============================================================
ECHO :: COPY WEB SURVEY FILES TO WEB ENTER FOLDER
ECHO :: ===============================================================
@ECHO ON
XCOPY %webSurvey%\docs\* %webEnterMergePath%\docs /I /E /Y
XCOPY %webSurvey%\EIWS_BLL_Core\* %webEnterMergePath%\EIWS_BLL_Core /I /E /Y
XCOPY %webSurvey%\Epi.DynamicForms.Core\* %webEnterMergePath%\Epi.DynamicForms.Core /I /E /Y
XCOPY %webSurvey%\Epi.Web\* %webEnterMergePath%\Epi.Web /I /E /Y
XCOPY %webSurvey%\Epi.Web.CheckCodeEngine\* %webEnterMergePath%\Epi.Web.CheckCodeEngine /I /E /Y
XCOPY %webSurvey%\Epi.Web.Common\* %webEnterMergePath%\Epi.Web.Common /I /E /Y
XCOPY %webSurvey%\Epi.Web.EF\* %webEnterMergePath%\Epi.Web.EF /I /E /Y
XCOPY %webSurvey%\Epi.Web.Interfaces\* %webEnterMergePath%\Epi.Web.Interfaces /I /E /Y
XCOPY %webSurvey%\Epi.Web.Modeling\* %webEnterMergePath%\Epi.Web.Modeling /I /E /Y
XCOPY %webSurvey%\Epi.Web.ServiceHost\* %webEnterMergePath%\Epi.Web.ServiceHost /I /E /Y
XCOPY %webSurvey%\Epi.Web.SurveyManager.Test\* %webEnterMergePath%\Epi.Web.SurveyManager.Test /I /E /Y
XCOPY %webSurvey%\Epi.Web.SurveyManager_Test\* %webEnterMergePath%\Epi.Web.SurveyManager_Test /I /E /Y
XCOPY %webSurvey%\Epi.Web.Test\* %webEnterMergePath%\Epi.Web.Test /I /E /Y
XCOPY %webSurvey%\Epi.Web.WCF.PublishServer\* %webEnterMergePath%\Epi.Web.WCF.PublishServer /I /E /Y
XCOPY %webSurvey%\packages\* %webEnterMergePath%\packages /I /E /Y
XCOPY %webSurvey%\SurveyManagerInterface\* %webEnterMergePath%\SurveyManagerInterface /I /E /Y
COPY %webSurvey%\"Epi Info Web Survey.sln" %webEnterMergePath%\"Epi Info Web Survey.sln" /I /E /Y
COPY %webSurvey%\"Epi Info Web Survey.vssscc" %webEnterMergePath%\"Epi Info Web Survey.vssscc" /I /E /Y
@ECHO OFF


CALL code -n %webEnterMergePath%


GOTO :EOF





ECHO :: ===============================================================
ECHO :: CALL GIT DIFF
ECHO :: ===============================================================
@ECHO ON
CD "%webEnterMergePath%"
CALL git diff
@ECHO OFF








ECHO :: ===============================================================
ECHO :: OPEN WINDOWS EXPLORER
ECHO :: ===============================================================
@ECHO ON
EXPLORER  %webEnterMergePath%
@ECHO OFF


GOTO :EOF









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