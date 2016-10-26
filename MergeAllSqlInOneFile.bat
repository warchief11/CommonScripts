REM This script assumes that all scripts are placed in folders in "../scripts" directory.
:: Constant vars
SET scriptname=scriptName.sql
SET scriptpathname=..\script\%scriptname%

ECHO off
cls
@del %scriptname%

:: Print statement at the start of the script
ECHO PRINT '%scriptname% script START...' > %scriptpathname%
ECHO PRINT 'Server: ' + @@SERVERNAME + ', Database: ' + DB_NAME() + ', Time: ' + CONVERT(VARCHAR,GETDATE(), 120) >> %scriptpathname%
ECHO GO >> %scriptpathname%

cls
ECHO Generating %scriptname% script. Please wait...

call :PROCESS_FILES tbl *.tab
call :PROCESS_FILES tbl alter*.sql
call :PROCESS_FILES view *.viw
call :PROCESS_FILES udt *.udt

GOTO :DONE

:CONCAT
:: Concat the supplied file to an output file preceded by a blank line
:: echo in concat - adding %1 to %2
echo. >> %2
type %1 >> %2
echo Added file %1
GOTO:EOF

REM Parameters required: Folder Name and files to search.
:PROCESS_FILES
cd ../%1
REM call PROCESS_FILES method recursively, and fix path after the call.
for /d %%a  in (*) do cd %%a & call :PROCESS_FILES %%a %2 & cd ../
REM call concat for all files in this folder, append script path (%%~dp0) before scriptpathname to handle nested paths
for /f "delims=" %%a in ('dir /b /o:N %2 2^>nul') do call :CONCAT %%a "%~dp0%scriptpathname%"


GOTO:EOF

:PROCESS_DIR
for /f "delims=" %%a in ( 'dir /b /o:N %2 2^>nul') do echo %%a
GOTO:EOF

:DONE
:: Print statement at the end of the script
echo. >>  %scriptpathname%
echo GO >>  %scriptpathname%
echo. >>  %scriptpathname%
echo PRINT '%scriptname% script END...' >>  %scriptpathname%
ECHO.
ECHO DONE!
pause
