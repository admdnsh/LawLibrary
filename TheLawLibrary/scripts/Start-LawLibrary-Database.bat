@echo off
echo ============================================================
echo   Law Library - Start Database
echo ============================================================
echo.

cd /d C:\Users\MS1\Project\TheLawLibrary

echo Starting MySQL and phpMyAdmin in Docker...
docker-compose -f docker\docker-compose.yml up -d

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================================
    echo   SUCCESS! Database is running!
    echo ============================================================
    echo.
    echo   MySQL Port: 3311
    echo   phpMyAdmin: http://localhost:8087
    echo
    echo   Database: law_library
    echo   Username: root
    echo   Password: lawlibrary123
    echo.
    echo   Now you can run your Flutter app!
    echo ============================================================
) else (
    echo.
    echo ERROR: Could not start database
    echo Please make sure Docker Desktop is running
)

echo.
pause
