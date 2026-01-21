@echo off
echo ============================================================
echo   Law Library - Testing API Connection
echo ============================================================
echo.

echo Testing API endpoints...
echo.

echo [1/3] Testing API root...
curl -s http://localhost:8088/

echo.
echo.
echo [2/3] Testing database connection...
curl -s http://localhost:8088/test_json_output.php

echo.
echo.
echo [3/3] Testing get_law_count endpoint...
curl -s http://localhost:8088/get_law_count.php

echo.
echo.
echo ============================================================
echo   Test Complete!
echo ============================================================
pause
