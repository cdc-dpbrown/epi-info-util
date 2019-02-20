@ECHO OFF
COLOR

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
    PAUSE
) ELSE (
    COLOR
    ECHO Epi-Info-Community-Edition - gone
)

:SKIP_DELETE

ECHO ON
COLOR 

SET /P o=OVERWRITE (GET) EPI INFO FROM GITHUB [Y/N]?
IF /I "%o%" EQU "Y" GOTO :GET_SOURCE
IF /I "%o%" EQU "N" GOTO :SKIP_GET_SOURCE
:SKIP_GET_SOURCE

:GET_SOURCE

git clone https://github.com/Epi-Info/Epi-Info-Community-Edition.git
CD Epi-Info-Community-Edition

COLOR 

REM [COMMENT] Dashboard: Added paired t-test results to HTML output
REM LAST CHECK-IN BEFORE CHANGE TO .NET 4.6.1 
git reset --hard b414fa8dac477e93c1c0dad2b4080425044657d5

REM [COMMENT] [BUILD] 7.2.2.16 11/2/2018
:: git reset --hard 3d7b050cbde62137f77d9ffc4175a0ae8c409935

:SKIP_GET_SOURCE

:UPDATE_VERSION_INFO
CD Epi-Info-Community-Edition

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

CALL code SolutionInfo.cs .\EpiInfoPlugin\Properties\AssemblyInfo.cs ".\StatisticsRepository\My Project\AssemblyInfo.vb"

:: ===============================================================
:: CHANGE TO RELEASE KEYS
:: ===============================================================
:: GET RELEASE KEY VERSION OF ConfigurationStatic.cs
NET USE M: \\cdc.gov\private\M131\ita3\_EI7\__BUILD REFERENCE__
:: OPEN IN CODE TO VERIFY ONLY KEYS HAVE CHANGED
CALL code .\EpiCore\ConfigurationStatic.cs

NET USE M: /DELETE

:: ===============================================================
::
:: ===============================================================

:: ===============================================================
::
:: ===============================================================

:: ===============================================================
::
:: ===============================================================


explorer .

net use X: \\cdc.gov\private\M131\ita3

IF EXIST ".\package-lock.json" (
    ECHO.
    ECHO Deleting package-lock.json
    DEL /Q .\package-lock.json
) 

