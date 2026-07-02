#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

echo "=== Package Version Monitor installation ==="

# Проверка Python
if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: python3 is not installed."
    exit 1
fi

# Проверка Ansible
if ! command -v ansible-playbook >/dev/null 2>&1; then
    echo "Error: ansible-playbook is not installed."
    exit 1
fi

# Проверка venv
if ! python3 -m venv --help >/dev/null 2>&1; then
    echo "Error: Python venv module is not available."
    echo
    echo "Ubuntu/WSL:"
    echo "    sudo apt install python3-venv"
    echo
    exit 1
fi

# Создание окружения
if [ ! -x "compare/venv/bin/python" ]; then
    echo "Creating virtual environment..."
    python3 -m venv compare/venv
fi

# Проверка pip внутри venv
if [ ! -x "compare/venv/bin/pip" ]; then
    echo "Error: pip is not available in the virtual environment."
    echo
    echo "Install it using:"
    echo "    sudo apt install python3-pip"
    exit 1
fi

echo "Installing Python dependencies..."
compare/venv/bin/pip install -r compare/requirements.txt

echo "Making scripts executable..."
chmod +x run.sh
chmod +x scripts/get_versions.sh

echo
echo "Installation completed."
echo
echo "Next steps:"
echo "  1. Configure inventory/hosts.ini"
echo "  2. Configure SSH access to remote hosts"
echo "  3. Add run.sh to crontab"
echo
echo "Example cron job: (job starts at 12 am)"
echo "0 12 * * * $(pwd)/run.sh" 
