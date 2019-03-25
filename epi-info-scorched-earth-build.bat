CLS
@ECHO OFF
COLOR 0E

SETLOCAL ENABLEDELAYEDEXPANSION

SET batchRootDirectory=%CD%
SET requiredFilesDirectory="C:\EpiInfo7ReleaseBuildFiles"
SET ei7=%batchRootDirectory%\Epi-Info-Community-Edition

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
CALL code -n SolutionInfo.cs %ei7%\EpiInfoPlugin\Properties\AssemblyInfo.cs %ei7%"\StatisticsRepository\My Project\AssemblyInfo.vb"

SET /P commit=COMMIT CHANGES TO GITHUB [Y/N]?
:ASK_COMMIT_CHANGES
IF /I "%commit%" EQU "Y" GOTO :COMMIT_CHANGES
IF /I "%commit%" EQU "N" GOTO :SKIP_COMMIT_CHANGES
GOTO :ASK_COMMIT_CHANGES
GOTO :SKIP_COMMIT_CHANGES
:COMMIT_CHANGES
CHDIR

:: START /WAIT %initialDirectory%\epi-info-git-commit.bat
ECHO :: ===============================================================
ECHO :: UPDATE VERSION
ECHO :: [BUILD] 7.2.2.V M/D/20YY 
ECHO :: ===============================================================
ECHO .
SET /P V=Minor Version(V): 
SET /P M=Month(M): 
SET /P D=Date(D): 
SET /P Y=Year(YY):
SET commit_message=[BUILD] 7.2.2.%V% %M%/%D%/20%Y%
ECHO %commit_message%
ECHO .

CD Epi-Info-Community-Edition
@ECHO ON
git status
git add SolutionInfo.cs .\EpiInfoPlugin\Properties\AssemblyInfo.cs ".\StatisticsRepository\My Project\AssemblyInfo.vb"
git status
git commit -m "%commit_message%"
git status
git pull --rebase
@ECHO OFF

SET /P commitCheck=ARE YOU SURE YOU WANT TO COMMIT [YES/N]?
:ASK_ARE_YOU_SURE_COMMIT_CHANGES
IF /I "%commitCheck%" EQU "YES" GOTO :ARE_YOU_SURE_COMMIT_CHANGES
IF /I "%commitCheck%" EQU "N" GOTO :SKIP_ARE_YOU_SURE_COMMIT_CHANGES
GOTO :ASK_ARE_YOU_SURE_COMMIT_CHANGES
:ARE_YOU_SURE_COMMIT_CHANGES
@ECHO ON
git push
@ECHO OFF

:SKIP_ARE_YOU_SURE_COMMIT_CHANGES
CD ..
PAUSE

:SKIP_COMMIT_CHANGES
:SKIP_UPDATE_VERSION


ECHO :: ===============================================================
ECHO :: COPY KEYS
ECHO :: ===============================================================
IF %QUIET%==TRUE GOTO:SKIP_KEYS_COPY
ECHO %requiredFilesDirectory%\Configuration_Static.cs
COPY /Y %requiredFilesDirectory%\Configuration_Static.cs %ei7%\Epi.Core\Configuration_Static.cs
::ECHO OPEN IN CODE TO VERIFY ONLY KEYS HAVE CHANGED
::CALL code -n .\Epi.Core\Configuration_Static.cs
::PAUSE

ECHO :: ===============================================================
ECHO :: REPLACE THE COMPONENT ART LICENSE
ECHO :: ===============================================================
COPY /Y %requiredFilesDirectory%\ComponentArt.Win.DataVisualization.lic %ei7%\Epi.Windows.AnalysisDashboard\ComponentArt.Win.DataVisualization.lic
COPY /Y %requiredFilesDirectory%\ComponentArt.Win.DataVisualization.lic %ei7%\Epi.Windows.Enter\ComponentArt.Win.DataVisualization.lic
COPY /Y %requiredFilesDirectory%\ComponentArt.Win.DataVisualization.lic %ei7%\EpiDashboard\ComponentArt.Win.DataVisualization.lic
::ECHO OPEN IN CODE TO VERIFY THE COMPONENT LICENSE HAS CHANGED
CALL code -n %ei7%
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


:: COPY /Y %requiredFilesDirectory%\dll\Epi.Data.PostgreSQL.dll %ei7%\build\release\Epi.Data.PostgreSQL.dll
:: COPY /Y %requiredFilesDirectory%\dll\FipsCrypto.dll %ei7%\build\release\FipsCrypto.dll
:: COPY /Y %requiredFilesDirectory%\dll\Interop.PortableDeviceApiLib.dll %ei7%\build\release\Interop.PortableDeviceApiLib.dll
:: COPY /Y %requiredFilesDirectory%\dll\Interop.PortableDeviceTypesLib.dll %ei7%\build\release\Interop.PortableDeviceTypesLib.dll
:: COPY /Y %requiredFilesDirectory%\dll\Mono.Security.dll %ei7%\build\release\Mono.Security.dll
:: COPY /Y %requiredFilesDirectory%\dll\Npgsql.dll %ei7%\build\release\Npgsql.dll

:: ECHO :: ===============================================================
:: ECHO :: COPY PROJECT (RELEASE) DIRECTORY
:: ECHO :: ===============================================================

:: IF NOT %QUIET%==TRUE PAUSE

:: ===============================================================
::
:: ===============================================================


ECHO :: ===============================================================
ECHO :: OPEN VS 2017 AND BUILD
ECHO :: ===============================================================
:: https://docs.microsoft.com/en-us/visualstudio/ide/reference/devenv-command-line-switches?view=vs-2017
:: devenv mysln.sln /build Release /project proj1 /projectconfig Release
CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe" %ei7%"\Epi Info 7.sln" /p:Configuration=Release /p:Platform=x86
IF NOT %QUIET%==TRUE PAUSE

ECHO :: ===============================================================
ECHO :: COPY LAUNCH EPI INFO EXECUTABLE 
ECHO :: ===============================================================
@ECHO ON
COPY /Y %requiredFilesDirectory%"\Launch Epi Info 7.exe" %ei7%"\build\Launch Epi Info 7.exe"
@ECHO OFF


ECHO :: ===============================================================
ECHO :: GIT CHECKOUT ALL - (UNDO KEYS AND LICENSE FILES)
ECHO :: ===============================================================
@ECHO ON
git checkout -- *
git status
@ECHO OFF
IF NOT %QUIET%==TRUE PAUSE

ECHO :: ===============================================================
ECHO :: PRUNE FILES RENAME AND ZIP
ECHO :: ===============================================================
:: START /WAIT %batchRootDirectory%\epi-info-prune-and-zip.bat

@ECHO ON
RMDIR /S /Q  %ei7%\Build\release\app.publish
RMDIR /S /Q  %ei7%\Build\release\Configuration
RMDIR /S /Q  %ei7%\Build\release\Logs
RMDIR /S /Q  %ei7%\Build\release\TestCases
RMDIR /S /Q  %ei7%\Build\release\Templates\Projects
RMDIR /S /Q  %ei7%\Build\release\Projects

XCOPY %requiredFilesDirectory%\projectsRelease\Projects %ei7%\build\release\Projects /I /E

DEL /Q %ei7%\Build\release\Output\*.html
DEL /Q %ei7%\Build\release\*.pdb
@ECHO OFF


ECHO :: ===============================================================
ECHO :: COPY RELEASE FOLDER TO EPI INFO 7
ECHO :: ===============================================================
XCOPY %ei7%\Build\release %ei7%\Build\"Epi Info 7" /I /E
XCOPY %ei7%\Build\"Epi Info 7" %ei7%\Build\"Epi Info 7" /I /E

ECHO :: ===============================================================
ECHO :: COPY EPI INFO 7 TO Epi Info 7@2019-03-24@16-34-32
ECHO :: ===============================================================
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "fullstamp=@%YYYY%-%MM%-%DD%@%HH%-%Min%-%Sec%"
echo fullstamp: "%fullstamp%
SET newName=%ei7%\Build\"Epi Info 7"%fullstamp%
XCOPY %ei7%\Build\"Epi Info 7" %newName% /I /E


ECHO :: ===============================================================
ECHO :: OPEN EPI MENU
ECHO :: ===============================================================
:: CD needed so Menu can find modules.
CD %ei7%\build\release
START %ei7%\build\release\Menu.exe
ECHO %CD%

:: ===============================================================

ECHO :: ===============================================================
ECHO :: OPEN WINDOWS EXPLORER IN BUILD DIRECTORY
ECHO :: ===============================================================
EXPLORER %ei7%\build
:: ===============================================================


ENDLOCAL
GOTO :EOF


:HELP
ECHO Q   Quiet mode
GOTO :EOF


:EOF