@echo off
echo ============================================================
echo   Law Library - Database Export from XAMPP
echo ============================================================
echo.

set MYSQL_PATH=C:\xampp\mysql\bin\mysqldump.exe
set OUTPUT_FILE=C:\Users\MS1\Project\TheLawLibrary\law_library_backup.sql

echo Exporting database from XAMPP...
echo.

"%MYSQL_PATH%" -uroot law_library > "%OUTPUT_FILE%" 2>nul

if %ERRORLEVEL% EQU 0 (
    echo ============================================================
    echo   SUCCESS! Database exported!
    echo   File: %OUTPUT_FILE%
    echo ============================================================
) else (
    echo ============================================================
    echo   ERROR: Could not export database!
    echo
    echo   Make sure:
    echo   1. XAMPP MySQL is running
    echo   2. Database 'law_library' exists
    echo
    echo   Trying alternative export...
    echo ============================================================
    echo.

    REM Try with password prompt
    "%MYSQL_PATH%" -uroot -p law_library > "%OUTPUT_FILE%"
)

echo.
pause
