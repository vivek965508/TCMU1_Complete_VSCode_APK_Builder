#!/usr/bin/env bash
set -e
echo "============================================================================"
echo "   TCMU-1 UNIVERSAL GSM MOTOR CONTROLLER & SMART BILLING APK BUILDER"
echo "============================================================================"
if ! command -v flutter &> /dev/null; then
    echo "[!] Flutter SDK is not installed on this machine."
    echo "    -> Upload this folder to GitHub to build the APK in 3 minutes via GitHub Actions (.github/workflows/build_apk.yml)"
    echo "    -> OR install Flutter SDK in VS Code and re-run this script."
    exit 1
fi

echo "[1/3] Initializing Android project wrapper..."
flutter create . --project-name tcmu1_universal_controller --org com.tcmu1.controller

echo "[2/3] Fetching packages..."
flutter pub get

echo "[3/3] Building Release APK..."
flutter build apk --release --no-tree-shake-icons

echo "✅ APK Ready at: build/app/outputs/flutter-apk/app-release.apk"
