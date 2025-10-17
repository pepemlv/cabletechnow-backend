@echo off
REM CableTechNow Backend - Quick Setup Script for Windows
REM This script helps you quickly set up the backend for development or production

echo 🚀 CableTechNow Backend Setup
echo ==============================

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js 16+ first.
    echo    Download from: https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js found
node --version

REM Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed. Please install npm first.
    pause
    exit /b 1
)

echo ✅ npm found
npm --version

REM Install dependencies
echo.
echo 📦 Installing dependencies...
npm install

if %errorlevel% equ 0 (
    echo ✅ Dependencies installed successfully
) else (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

REM Check if .env file exists
if not exist ".env" (
    echo.
    echo ⚠️  .env file not found
    echo 📝 Creating .env file from template...
    copy .env.example .env
    echo ✅ .env file created
    echo.
    echo 🔧 IMPORTANT: Please update .env file with your actual values:
    echo    - STRIPE_SECRET_TEST=your_actual_stripe_key
    echo    - STRIPE_WEBHOOK_SECRET=your_actual_webhook_secret
    echo.
) else (
    echo ✅ .env file found
)

echo.
echo 🎉 Setup complete!
echo.
echo 📋 Next steps:
echo    1. Update .env file with your Stripe keys
echo    2. Run 'npm start' to start the server
echo    3. Test at http://localhost:4000
echo.
echo 🚀 For production deployment, see DEPLOYMENT.md
echo 📖 For full documentation, see README.md
echo.
pause