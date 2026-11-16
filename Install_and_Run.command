#!/bin/bash
set -e

PROJECT="$HOME/Downloads/Fayez Online Shop 4"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_APP="$SOURCE_DIR/Fayez_Online_Shop_Rebuilt.py"

if [ ! -f "$SOURCE_APP" ]; then
  echo "ERROR: Fayez_Online_Shop_Rebuilt.py is missing from this extracted folder."
  read -r -p "Press Enter to close..."
  exit 1
fi

if [ ! -d "$PROJECT" ]; then
  echo "ERROR: Could not find: $PROJECT"
  echo "Please keep your existing project folder named 'Fayez Online Shop 4' inside Downloads."
  read -r -p "Press Enter to close..."
  exit 1
fi

if [ -f "$PROJECT/shop.db" ]; then
  echo "Existing shop.db found. It will be preserved."
elif [ -f "$PROJECT/fayez_online_shop.db" ]; then
  echo "Existing fayez_online_shop.db found. It will be preserved."
else
  echo "WARNING: No existing shop database found in the project folder."
  echo "Stopping to avoid creating a fresh empty store by mistake."
  read -r -p "Press Enter to close..."
  exit 1
fi

if [ -f "$PROJECT/app.py" ]; then
  cp "$PROJECT/app.py" "$PROJECT/app.py.before_fayez_update_$(date +%Y%m%d_%H%M%S).bak"
fi
cp "$SOURCE_APP" "$PROJECT/app.py"
cp "$SOURCE_DIR/requirements.txt" "$PROJECT/requirements.txt"

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: Python 3 was not found. Install Python 3 from python.org first."
  read -r -p "Press Enter to close..."
  exit 1
fi

if [ ! -x "$PROJECT/.venv/bin/python" ]; then
  python3 -m venv "$PROJECT/.venv"
fi
"$PROJECT/.venv/bin/python" -m pip install --upgrade pip
"$PROJECT/.venv/bin/python" -m pip install -r "$PROJECT/requirements.txt"

cd "$PROJECT"
echo "Starting Fayez Online Shop..."
echo "Keep this Terminal window open while using the shop."
"$PROJECT/.venv/bin/python" -u "$PROJECT/app.py"
