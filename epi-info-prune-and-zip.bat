@ECHO OFF
COLOR

ECHO %CD%
CD Epi-Info-Community-Edition
ECHO %CD%

:: ===============================================================
::
:: ===============================================================


:: ===============================================================
:: DELETE THEN COPY PROJECT (RELEASE) DIRECTORY
:: ===============================================================


IF NOT EXIST "build" (
    COLOR
    MKDIR build
)
IF NOT EXIST ".\build\release" (
    COLOR
    CD build
    MKDIR release
    IF NOT EXIST "release" (
        COLOR
        CD build
        MKDIR release
        CD..
    )


    CD..
)

CD Epi-Info-Community-Edition\build\release
DELETE /Q *


:: ===============================================================
:: PRUNE FILES
:: ===============================================================

DEL /Q .\package-lock.json

IF EXIST ".\package-lock.json" (
    ECHO.
    ECHO Deleting package-lock.json
    DEL /Q .\package-lock.json
)

:: ===============================================================
:: RENAME AND ZIP
:: ===============================================================


:: explorer .

