#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "--- TextLens: Azerbaijani OCR Setup ---"

# 1. Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew (Package Manager)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Install Tesseract, Azerbaijani Data, and Poppler (for PDFs)
echo "Ensuring OCR engines and PDF tools are installed..."
brew install tesseract tesseract-lang poppler

# 3. Install Python Dependencies
echo "Setting up Python environment..."
pip3 install pdf2image --quiet

# 4. Start the app
echo "Launching Server..."
python3 ocr_server.py &
SERVER_PID=$!

sleep 2
open "http://localhost:7777"

# Handle shutdown
trap "kill $SERVER_PID" EXIT
wait $SERVER_PID
