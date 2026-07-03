#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

echo "=== Установка Package Version Monitor ==="

echo "Обновление списка пакетов..."
sudo apt update

echo "Установка зависимостей..."
sudo apt install -y \
    ansible \
    python3 \
    python3-pip \
    python3-venv

echo "Создание виртуального окружения..."

if [ ! -x "compare/venv/bin/python" ]; then
    python3 -m venv compare/venv
fi

echo "Установка Python-зависимостей..."
compare/venv/bin/python -m pip install -r compare/requirements.txt

echo "Выдача прав на выполнение..."
chmod +x run.sh
chmod +x scripts/get_versions.sh

echo
echo "Установка завершена."
echo
echo "Дальнейшие действия:"
echo "1. Заполните inventory/hosts.ini."
echo "2. Настройте SSH-доступ до удалённых машин."
echo "3. Запустите ./run.sh или добавьте его в cron."
