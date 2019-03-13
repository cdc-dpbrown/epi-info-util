CLS
@ECHO OFF
COLOR

setLocal EnableDelayedExpansion

SET EI_KEY_QUIET=Q

SET EI_ARGS=%1
ECHO EI_ARGS=%EI_ARGS%
ECHO EI_KEY_QUIET=%EI_KEY_QUIET%
SET EI_QUIET=FALSE

IF NOT "x!EI_ARGS:%EI_KEY_QUIET%=!"=="x%EI_ARGS%" SET EI_QUIET=TRUE
::ECHO QUIET = %EI_QUIET%
::ECHO ARGS = %EI_ARGS%

:: ===============================================================
:: DELETE EPI INFO FOLDER
:: ===============================================================
IF %EI_QUIET%==TRUE GOTO:DELETEEPIINFOFOLDER
SET /P d=DELETE EPI INFO FOLDER [Y/N]?
IF /I "%d%" EQU "Y" GOTO :DELETEEPIINFOFOLDER
IF /I "%d%" EQU "N" GOTO :SKIP_DELETE
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


:: ===============================================================
:: GET SOURCE - GIT CLONE EPI INFO
:: ===============================================================
IF %EI_QUIET%==TRUE GOTO:GET_SOURCE
SET /P o=OVERWRITE (GET) EPI INFO FROM GITHUB [Y/N]?
IF /I "%o%" EQU "Y" GOTO :GET_SOURCE
IF /I "%o%" EQU "N" GOTO :SKIP_GET_SOURCE
:SKIP_GET_SOURCE

:GET_SOURCE

ECHO

git clone https://github.com/Epi-Info/Epi-Info-Community-Edition.git
CD Epi-Info-Community-Edition

COLOR 
IF NOT %EI_QUIET%==TRUE PAUSE
REM [COMMENT] Dashboard: Added paired t-test results to HTML output
REM LAST CHECK-IN BEFORE CHANGE TO .NET 4.6.1 
::git reset --hard b414fa8dac477e93c1c0dad2b4080425044657d5

REM [COMMENT] [BUILD] 7.2.2.16 11/2/2018
::git reset --hard 3d7b050cbde62137f77d9ffc4175a0ae8c409935

:: ===============================================================
:SKIP_GET_SOURCE
:: ===============================================================

:: ===============================================================
:: UPDATE VERSION
:: ===============================================================

:: SolutionInfo.cs
:: [assembly: AssemblyVersion("7.2.*")]
:: [assembly: AssemblyFileVersion("7.2.2.16")]
:: [assembly: AssemblyInformationalVersion("7.2.2.16")]
:: [assembly: SatelliteContractVersion("7.0.0.0")]
:: [assembly: Epi.AssemblyReleaseDateAttribute("11/02/2018")]

:: AssemblyInfo.cs
:: [assembly: AssemblyVersion("7.2.2.16")]
:: [assembly: AssemblyFileVersion("7.2.2.16")]

:: AssemblyInfo.vb
:: <Assembly: AssemblyVersion("7.2.2.16")>
:: <Assembly: AssemblyFileVersion("7.2.2.16")>
IF %EI_QUIET%==TRUE GOTO:SKIP_UPDATE_VERSION
CALL code -n SolutionInfo.cs .\EpiInfoPlugin\Properties\AssemblyInfo.cs ".\StatisticsRepository\My Project\AssemblyInfo.vb"
:SKIP_UPDATE_VERSION
:: ===============================================================


:: ===============================================================
:: COPY KEYS
:: ===============================================================
IF %EI_QUIET%==TRUE GOTO:SKIP_KEYS_COPY
:: ---------------------------------------------------------------
:: CHANGE TO RELEASE KEYS
:: ---------------------------------------------------------------
:: GET RELEASE KEY VERSION OF ConfigurationStatic.cs
COPY /Y "C:\requiredFiles (ei7)\Configuration_Static.cs" .\Epi.Core\Configuration_Static.cs
::ECHO OPEN IN CODE TO VERIFY ONLY KEYS HAVE CHANGED
::CALL code -n .\Epi.Core\Configuration_Static.cs
::PAUSE
:: ---------------------------------------------------------------
:: REPLACE THE COMPONENT ART LICENSE
:: ---------------------------------------------------------------
COPY /Y "C:\requiredFiles (ei7)\ComponentArt.Win.DataVisualization.lic" .\Epi.Windows.AnalysisDashboard\ComponentArt.Win.DataVisualization.lic
COPY /Y "C:\requiredFiles (ei7)\ComponentArt.Win.DataVisualization.lic" .\Epi.Windows.Enter\ComponentArt.Win.DataVisualization.lic
COPY /Y "C:\requiredFiles (ei7)\ComponentArt.Win.DataVisualization.lic" .\EpiDashboard\ComponentArt.Win.DataVisualization.lic
::ECHO OPEN IN CODE TO VERIFY THE COMPONENT LICENSE HAS CHANGED
CALL code -n .
PAUSE
:SKIP_KEYS_COPY
:: ===============================================================


:: ===============================================================
:: COPY DLLS
:: ===============================================================
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

:: ===============================================================
:: COPY PROJECT (RELEASE) DIRECTORY
:: ===============================================================

IF NOT %EI_QUIET%==TRUE PAUSE

:: ===============================================================
::
:: ===============================================================




:: ===============================================================
:: OPEN VS 2017 AND BUILD
:: ===============================================================
:: https://docs.microsoft.com/en-us/visualstudio/ide/reference/devenv-command-line-switches?view=vs-2017
:: devenv mysln.sln /build Release /project proj1 /projectconfig Release

CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe" "Epi Info 7.sln" /p:Configuration=Release /p:Platform=x86
IF NOT %EI_QUIET%==TRUE PAUSE

:: ===============================================================
:: COPY LAUNCH EPI INFO EXECUTABLE 
:: ===============================================================
@ECHO ON
COPY /Y "C:\requiredFiles (ei7)\Launch Epi Info 7.exe" ".\build\release\Launch Epi Info 7.exe"
@ECHO OFF


@ECHO ON
git checkout -- *
git status
IF NOT %EI_QUIET%==TRUE PAUSE
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


::explorer ".\build\release\"
".\build\release\Menu.exe"


endlocal

:EOF