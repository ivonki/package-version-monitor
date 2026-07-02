#!/bin/bash 

set -e

cd "$(dirname '$0')"

echo Проверка наличия файла инвентаря
if [ ! -f "inventory/hosts.ini" ]; then
	echo "Error: inventory/hosts.ini not found"
	exit 1
fi

echo "Сбор версий программ"
ansible-playbook -i inventory/hosts.ini playbooks/collect.yaml

echo "Сравнение версий программ"
compare/venv/bin/python compare/compare.py

echo "Готов"
