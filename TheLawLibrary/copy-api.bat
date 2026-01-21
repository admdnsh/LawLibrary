@echo off
echo ============================================================
echo   Creating Docker Setup for Law Library (PHP API + MySQL)
echo ============================================================
echo.

echo Copying PHP API from XAMPP to Docker project...
xcopy "C:\xampp\htdocs\law_library_api" "C:\Project\TheLawLibrary\api" /E /I /Y

echo.
echo ============================================================
echo   PHP API copied successfully!
echo ============================================================
pause
