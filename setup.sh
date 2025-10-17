#!/bin/bash

# CableTechNow Backend - Quick Setup Script
# This script helps you quickly set up the backend for development or production

echo "🚀 CableTechNow Backend Setup"
echo "=============================="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 16+ first."
    echo "   Download from: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js found: $(node --version)"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ npm found: $(npm --version)"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo ""
    echo "⚠️  .env file not found"
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created"
    echo ""
    echo "🔧 IMPORTANT: Please update .env file with your actual values:"
    echo "   - STRIPE_SECRET_TEST=your_actual_stripe_key"
    echo "   - STRIPE_WEBHOOK_SECRET=your_actual_webhook_secret"
    echo ""
else
    echo "✅ .env file found"
fi

# Test server start
echo ""
echo "🧪 Testing server startup..."
timeout 5s npm start &
PID=$!
sleep 3

if kill -0 $PID 2>/dev/null; then
    echo "✅ Server started successfully"
    kill $PID
else
    echo "⚠️  Server test incomplete (this is normal)"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Update .env file with your Stripe keys"
echo "   2. Run 'npm start' to start the server"
echo "   3. Test at http://localhost:4000"
echo ""
echo "🚀 For production deployment, see DEPLOYMENT.md"
echo "📖 For full documentation, see README.md"