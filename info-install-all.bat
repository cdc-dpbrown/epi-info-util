
CLS
@ECHO OFF
COLOR

ECHO.
WHERE NPM
IF %ERRORLEVEL% EQU 0 (
     ECHO NPM: GOOD
     CALL npm -v
) ELSE (
     ECHO NPM: NO
)

ECHO.
WHERE YARN
IF %ERRORLEVEL% EQU 0 (
     ECHO YARN: GOOD
     CALL yarn -v
) ELSE (
     ECHO YARN: NO
)

ECHO.
WHERE CODE
IF %ERRORLEVEL% EQU 0 (
     ECHO CODE: GOOD
     CALL code -v
) ELSE (
     ECHO CODE: NO
)

ECHO.
WHERE NODE
IF %ERRORLEVEL% EQU 0 (
     ECHO NODE: GOOD
     CALL node -v
) ELSE (
     ECHO NODE: NO
)

REM npm install --save yarn-install
REM npm un yarn-install
