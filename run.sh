#!/bin/bash 

set -e

echo "Сбор версий программ"
ansible-playbook -i inventory/hosts.ini playbooks/collect.yaml

echo "Сравнение версий программ"
compare/venv/bin/python compare/compare.py

echo "Готов"
