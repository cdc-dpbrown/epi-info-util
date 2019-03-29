@ECHO OFF
COLOR

IF EXIST ".\epi-info-boilerplate" (
    ECHO.
    ECHO Deleting epi-info-boilerplate directory
) 

IF EXIST ".\epi-info-boilerplate" (
    RMDIR /S /Q .\epi-info-boilerplate
) 

IF EXIST ".\epi-info-boilerplate" (
    COLOR 0A
    ECHO epi-info-boilerplate - still there - try restartExplorer.bat
    PAUSE
) ELSE (
    COLOR
    ECHO epi-info-boilerplate - gone
)

ECHO ON
COLOR 

REM git clone --depth 1 --single-branch --branch master https://github.com/cdc-dpbrown/epi-info-boilerplate.git epi-info-boilerplate
git clone https://github.com/cdc-dpbrown/epi-info-boilerplate.git epi-info-boilerplate
cd epi-info-boilerplate

COLOR 

REM [comment]
::git reset --hard 5bac8b278467a63d6c085387b8ae8cb7e36563c5

REM [comment] 
::git reset --hard 3c632651022ffe4f43f2b1b4c12a9a5cc2c7e828

IF EXIST ".\package-lock.json" (
    ECHO.
    ECHO Deleting package-lock.json
    DEL /Q .\package-lock.json
) 

CALL yarn
:: yarn list --pattern "epi-"

CALL yarn start