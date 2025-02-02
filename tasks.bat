@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F %%a IN ('echo prompt $E ^| cmd') DO set "ESC=%%a"
SET /A visible= 2
SET /A selected=6
Set _fBlack=[30m
FOR /L %%i IN (0, 1, 23) DO echo.

:reload
SET count=0
FOR /F "tokens=* USEBACKQ" %%F IN (`tasklist`) DO (
  SET var[!count!]=%%F
  SET /A count=!count!+1
)

:Start
ECHO %ESC%[24A%var[0]%
ECHO %var[1]%
SET /A tmp= !visible! + 20
FOR /L %%i IN (%visible%, 1, %tmp%) DO (
  CALL SET output=%%var[%%i]%%
  if %%i EQU %selected% echo %ESC%[107m%_fBlack%!output!%ESC%[0m
  if %%i NEQ %selected% echo !output!
)

:choose
choice /c wskrfq /n
if %errorlevel%==1 goto up
if %errorlevel%==2 goto down
if %errorlevel%==3 goto kill
if %errorlevel%==4 goto reload
if %errorlevel%==5 goto killf
if %errorlevel%==6 goto END
goto choose

:up
set /a tmp= !selected! - !visible!
if %tmp%==3 if %visible% GTR 2 SET /A visible=!visible! - 1
set /a tmp= !selected! - 1
if %tmp% GTR 1 SET /A selected=!selected! - 1
goto Start

:down
set /a tmp= !selected! - !visible!
set /a tmp1= !visible! + 21
if %tmp%==17 if %tmp1% LSS %count% SET /A visible=!visible! + 1
set /a tmp= !selected! + 1
if %count% GTR %tmp% SET /A selected=!selected! + 1
goto Start

:kill
call set tmp=%%var[!selected!]%%
for /f "tokens=2" %%i in ("%tmp%") do set word2=%%i
taskkill /pid %word2%
set /a tmp= !selected! - !visible!
if %tmp%==3 if %visible% GTR 2 SET /A visible=!visible! - 1
set /a tmp= !selected! - 1
if %tmp% GTR 1 SET /A selected=!selected! - 1
goto reload

:killf
call set tmp=%%var[!selected!]%%
for /f "tokens=2" %%i in ("%tmp%") do set word2=%%i
taskkill /pid %word2% /F
set /a tmp= !selected! - !visible!
if %tmp%==3 if %visible% GTR 2 SET /A visible=!visible! - 1
set /a tmp= !selected! - 1
if %tmp% GTR 1 SET /A selected=!selected! - 1
goto reload

:END
ENDLOCAL
