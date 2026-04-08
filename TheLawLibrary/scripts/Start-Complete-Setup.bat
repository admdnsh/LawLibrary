@echo off
echo ============================================================
echo   Law Library - Complete Docker Setup
echo ============================================================
echo.

cd /d C:\Users\MS1\Project\TheLawLibrary

echo [1/4] Starting Docker containers...
docker-compose -f docker\docker-compose.yml up -d

echo.
echo [2/4] Waiting for MySQL to be ready...
timeout /t 10 /nobreak >nul

echo.
echo [3/4] Importing database schema...
type law_library\database_setup.sql | docker-compose -f docker\docker-compose.yml exec -T mysql mysql -uroot -plawlibrary123 law_library

echo.
echo [4/4] Testing API connection...
curl http://localhost:8088/get_law_count.php

echo.
echo ============================================================
echo   Setup Complete!
echo ============================================================
echo.
echo   API:        http://localhost:8088
echo   MySQL:      localhost:3311
echo   phpMyAdmin: http://localhost:8087
echo.
echo   Flutter needs to connect to:
echo     - Windows/Mac: http://localhost:8088
echo     - Android Emulator: http://10.0.2.2:8088
echo.
pause
