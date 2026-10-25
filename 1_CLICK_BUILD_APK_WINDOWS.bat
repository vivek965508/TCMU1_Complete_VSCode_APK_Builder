@echo off
title TCMU-1 Universal GSM Motor Controller - 1-Click APK Builder
color 0A
echo ============================================================================
echo    TCMU-1 UNIVERSAL GSM MOTOR CONTROLLER ^& SMART BILLING APK BUILDER
echo ============================================================================
echo.

where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    color 0E
    echo [!] aapke computer mein abhi Flutter SDK installed nahi hai!
    echo.
    echo APK banane ke 2 sabse aasan tareeke hain:
    echo.
    echo TAREEKA 1 (Bina 5GB Android Studio download kiye - GitHub Cloud se 3 min mein):
    echo   1. Is folder ko GitHub.com par ek nayi repository mein upload kar dein.
    echo   2. GitHub ke "Actions" tab mein jayein — wahan apne aap APK ban jayega!
    echo   3. "TCMU1-Smart-Billing-Release-APK" par click karke seedha APK download karein.
    echo.
    echo TAREEKA 2 (Apne PC / VS Code mein Flutter install karke):
    echo   1. VS Code kholein -> Extensions mein "Flutter" install karein.
    echo   2. Fir is file (1_CLICK_BUILD_APK_WINDOWS.bat) par double-click karein.
    echo.
    pause
    exit /b
)

echo [1/4] Generating full Android Gradle binary wrappers...
call flutter create . --project-name tcmu1_universal_controller --org com.tcmu1.controller

echo.
echo [2/4] Downloading packages (telephony, local_auth, shared_preferences, sqflite)...
call flutter pub get

echo.
echo [3/4] Compiling Release APK (TCMU-1 Smart Billing)...
call flutter build apk --release --no-tree-shake-icons

echo.
echo ============================================================================
echo [SUCCESS!] Aapka APK ban kar taiyar hai!
echo Location: build\app\outputs\flutter-apk\app-release.apk
echo ============================================================================
explorer build\app\outputs\flutter-apk
pause
