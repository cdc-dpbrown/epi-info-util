CLS
@ECHO OFF
COLOR 0E

SETLOCAL ENABLEDELAYEDEXPANSION

SET KEY_QUIET=Q
SET KEY_HELP=/?

SET ARGS=%1
IF "%ARGS%" EQU "" SET ARGS=1
::ECHO ARGS=%ARGS%
::ECHO KEY_QUIET=%KEY_QUIET%
SET QUIET=FALSE
SET HELP=FALSE

IF NOT "x!ARGS:%KEY_QUIET%=!"=="x%ARGS%" SET QUIET=TRUE
IF NOT "x!ARGS:%KEY_HELP%=!"=="x%ARGS%" GOTO :HELP
::ECHO QUIET: %QUIET%
::ECHO ARGS: %ARGS%

::GOTO:EOF
ECHO :: ===============================================================
ECHO :: DELETE EPI INFO FOLDER
ECHO :: ===============================================================
IF %QUIET%==TRUE GOTO :DELETEEPIINFOFOLDER
:ASK_SKIP_DELETE
SET /P d=DELETE EPI INFO FOLDER [Y/N]?
IF /I "%d%" EQU "Y" GOTO :DELETEEPIINFOFOLDER
IF /I "%d%" EQU "N" GOTO :SKIP_DELETE
GOTO :ASK_SKIP_DELETE
GOTO :SKIP_DELETE
:DELETEEPIINFOFOLDER

IF EXIST ".\Epi-Info-Community-Edition" (
    ECHO.
    ECHO Deleting Epi-Info-Community-Edition directory
) 

IF EXIST ".\Epi-Info-Community-Edition" (
    RMDIR /S /Q .\Epi-Info-Community-Edition
) 

IF EXIST ".\Epi-Info-Community-Edition" (
    COLOR 0A
    ECHO Epi-Info-Community-Edition - still there - try restartExplorer.bat
    EXIT /B
) ELSE (
    COLOR
    ECHO Epi-Info-Community-Edition - gone
)

:SKIP_DELETE
:: ===============================================================
:: END OF DELETE EPI INFO FOLDER
:: ===============================================================


ECHO :: ===============================================================
ECHO :: GET SOURCE - GIT CLONE EPI INFO REPO
ECHO :: ===============================================================
IF %QUIET%==TRUE GOTO:GET_SOURCE
:ASK_GET_SOURCE
SET /P o=OVERWRITE (GET) EPI INFO FROM GITHUB [Y/N]?
IF /I "%o%" EQU "Y" GOTO :GET_SOURCE
IF /I "%o%" EQU "N" GOTO :SKIP_GET_SOURCE
GOTO :ASK_GET_SOURCE
GOTO :SKIP_GET_SOURCE
:GET_SOURCE

@ECHO ON
git clone https://github.com/Epi-Info/Epi-Info-Community-Edition.git
@ECHO OFF

COLOR 
:: IF NOT %QUIET%==TRUE PAUSE
REM [COMMENT] Dashboard: Added paired t-test results to HTML output
REM LAST CHECK-IN BEFORE CHANGE TO .NET 4.6.1 
::git reset --hard b414fa8dac477e93c1c0dad2b4080425044657d5

REM [COMMENT] [BUILD] 7.2.2.16 11/2/2018
::git reset --hard 3d7b050cbde62137f77d9ffc4175a0ae8c409935

:SKIP_GET_SOURCE
:: ===============================================================
:: END OF GET SOURCE - GIT CLONE EPI INFO REPO
:: ===============================================================

@ECHO ON
CD Epi-Info-Community-Edition
@ECHO OFF

IF %QUIET%==TRUE GOTO:SKIP_UPDATE_VERSION
ECHO :: ===============================================================
ECHO :: UPDATE VERSION
ECHO :: ===============================================================
ECHO .
ECHO :: SolutionInfo.cs
ECHO :: [assembly: AssemblyVersion("7.2.*")]
ECHO :: [assembly: AssemblyFileVersion("7.2.2.V")]
ECHO :: [assembly: AssemblyInformationalVersion("7.2.2.V")]
ECHO :: [assembly: SatelliteContractVersion("7.0.0.0")]
ECHO :: [assembly: Epi.AssemblyReleaseDateAttribute("MM/DD/YYYY")]
ECHO .
ECHO :: AssemblyInfo.cs
ECHO :: [assembly: AssemblyVersion("7.2.2.V")]
ECHO :: [assembly: AssemblyFileVersion("7.2.2.V")]
ECHO .
ECHO :: AssemblyInfo.vb
ECHO :: Assembly: AssemblyVersion("7.2.2.V")
ECHO :: Assembly: AssemblyFileVersion("7.2.2.V")
ECHO .
ECHO An instance of Visual Studio Code will open and you can make the changes there.
ECHO .
PAUSE
CALL code -n SolutionInfo.cs .\EpiInfoPlugin\Properties\AssemblyInfo.cs ".\StatisticsRepository\My Project\AssemblyInfo.vb"

SET /P commit=COMMIT CHANGES TO GITHUB [Y/N]?
:ASK_COMMIT_CHANGES
IF /I "%commit%" EQU "Y" GOTO :COMMIT_CHANGES
IF /I "%commit%" EQU "N" GOTO :SKIP_COMMIT_CHANGES
GOTO :ASK_COMMIT_CHANGES
GOTO :SKIP_COMMIT_CHANGES
:COMMIT_CHANGES
CHDIR
START /WAIT ..\epi-info-git-commit.bat
PAUSE

:SKIP_COMMIT_CHANGES
:SKIP_UPDATE_VERSION
:: ===============================================================
:: END OF UPDATE VERSION
:: ===============================================================


ECHO :: ===============================================================
ECHO :: COPY KEYS
ECHO :: ===============================================================
IF %QUIET%==TRUE GOTO:SKIP_KEYS_COPY
:: ---------------------------------------------------------------
:: CHANGE TO RELEASE KEYS
:: ---------------------------------------------------------------
:: GET RELEASE KEY VERSION OF ConfigurationStatic.cs
COPY /Y "C:\requiredFiles (ei7)\Configuration_Static.cs" .\Epi.Core\Configuration_Static.cs
::ECHO OPEN IN CODE TO VERIFY ONLY KEYS HAVE CHANGED
::CALL code -n .\Epi.Core\Configuration_Static.cs
::PAUSE

ECHO :: ===============================================================
ECHO :: REPLACE THE COMPONENT ART LICENSE
ECHO :: ===============================================================
COPY /Y "C:\requiredFiles (ei7)\ComponentArt.Win.DataVisualization.lic" .\Epi.Windows.AnalysisDashboard\ComponentArt.Win.DataVisualization.lic
COPY /Y "C:\requiredFiles (ei7)\ComponentArt.Win.DataVisualization.lic" .\Epi.Windows.Enter\ComponentArt.Win.DataVisualization.lic
COPY /Y "C:\requiredFiles (ei7)\ComponentArt.Win.DataVisualization.lic" .\EpiDashboard\ComponentArt.Win.DataVisualization.lic
::ECHO OPEN IN CODE TO VERIFY THE COMPONENT LICENSE HAS CHANGED
CALL code -n .
PAUSE
:SKIP_KEYS_COPY
:: ===============================================================


ECHO :: ===============================================================
ECHO :: COPY DLLS
ECHO :: ===============================================================
IF NOT EXIST "build" (
    COLOR
    MKDIR build
)
IF NOT EXIST ".\build\release" (
    COLOR
    CD build
    MKDIR release
    CD..
)
COPY /Y "C:\requiredFiles (ei7)\dll\Epi.Data.PostgreSQL.dll" .\build\release\Epi.Data.PostgreSQL.dll
COPY /Y "C:\requiredFiles (ei7)\dll\FipsCrypto.dll" .\build\release\FipsCrypto.dll
COPY /Y "C:\requiredFiles (ei7)\dll\Interop.PortableDeviceApiLib.dll" .\build\release\Interop.PortableDeviceApiLib.dll
COPY /Y "C:\requiredFiles (ei7)\dll\Interop.PortableDeviceTypesLib.dll" .\build\release\Interop.PortableDeviceTypesLib.dll
COPY /Y "C:\requiredFiles (ei7)\dll\Mono.Security.dll" .\build\release\Mono.Security.dll
COPY /Y "C:\requiredFiles (ei7)\dll\Npgsql.dll" .\build\release\Npgsql.dll

ECHO :: ===============================================================
ECHO :: COPY PROJECT (RELEASE) DIRECTORY
ECHO :: ===============================================================

IF NOT %QUIET%==TRUE PAUSE

:: ===============================================================
::
:: ===============================================================




:: ===============================================================
:: OPEN VS 2017 AND BUILD
:: ===============================================================
:: https://docs.microsoft.com/en-us/visualstudio/ide/reference/devenv-command-line-switches?view=vs-2017
:: devenv mysln.sln /build Release /project proj1 /projectconfig Release

CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe" "Epi Info 7.sln" /p:Configuration=Release /p:Platform=x86
IF NOT %QUIET%==TRUE PAUSE

:: ===============================================================
:: COPY LAUNCH EPI INFO EXECUTABLE 
:: ===============================================================
@ECHO ON
COPY /Y "C:\requiredFiles (ei7)\Launch Epi Info 7.exe" ".\build\release\Launch Epi Info 7.exe"
@ECHO OFF


@ECHO ON
git checkout -- *
git status
IF NOT %QUIET%==TRUE PAUSE
@ECHO OFF


:: ===============================================================
:: DELETE THEN COPY PROJECT (RELEASE) DIRECTORY
:: ===============================================================


:: ===============================================================
:: PRUNE FILES
:: ===============================================================


:: ===============================================================
:: RENAME AND ZIP
:: ===============================================================


:: explorer ".\build\release\"


:: ===============================================================
:: OPEN EPI MENU
:: ===============================================================
:: CD needed so Menu can find modules.
CD .\build\release
START Menu.exe
CD ..\..
:: ===============================================================


ENDLOCAL
GOTO :EOF


:HELP
ECHO Q   Quiet mode
GOTO :EOF


:EOF
