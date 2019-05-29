CLS
@ECHO OFF
COLOR

ECHO :: ===============================================================
ECHO :: SET LOCAL VARIABLES
ECHO :: ===============================================================
SETLOCAL ENABLEDELAYEDEXPANSION
SET batchRootDirectory=%CD%
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
ECHO BATCH ROOT DIRECTORY: %batchRootDirectory%

ECHO.
WHERE NPM
IF %ERRORLEVEL% EQU 0 (
     ECHO NPM: GOOD
     CALL npm -v
) ELSE (
     ECHO NPM: NO
)

ECHO.
WHERE NODE
IF %ERRORLEVEL% EQU 0 (
     ECHO NODEJS: GOOD
     CALL node -v
) ELSE (
     ECHO NODEJS: NO
)

:: STOP HERE IF NODE AND NPM ARE NOT INSTALLED
:: https://nodejs.org/en/download/

:: SELENIUM SIDE RUNNER
CALL npm install -g selenium-side-runner
:: CHROME
CALL npm install -g chromedriver
:: EDGE
CALL npm install -g edgedriver
:: FIREFOX
CALL npm install -g geckodriver
:: IE
CALL npm install -g iedriver

CALL npm view selenium-side-runner
CALL npm view chromedriver
CALL npm view edgedriver
CALL npm view geckodriver
CALL npm view iedriver

ENDLOCAL
GOTO :EOF

:HELP
ECHO :: ===============================================================
ECHO :: HELP
ECHO :: ===============================================================
ECHO start chrome https://www.seleniumhq.org/selenium-ide/docs/en/introduction/command-line-runner/
GOTO :EOF

:EOF
