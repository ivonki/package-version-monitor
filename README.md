# Сбор версий пакетов удаленных машин с использованием Ansible

## Проект собирает версии пакетов с удаленных Linux хостов с использованием Ansible, сравнивает их с предыдущими версиями и логирует изменения.

### Требования:
* Ansible
* Python 3.7+
* SSH доступ с главного узла на управляемые машины

### Архитектура

```text
package-version-monitor/
├── compare/
├── data/
│   ├── current/
│   ├── history/
│   └── incoming/
├── inventory/
├── logs/
├── playbooks/
├── scripts/
├── run.sh
└── README.md
```

1. Инициализация скрипта ./run.sh запускает два файла: playbooks/collect.yaml и compare/compare.py

2. Файл playbooks/collect.yaml запускает файл scripts/get_versions.sh, который собирает версии указанных пакетов, корректирует вывод 

3. Хост с Ansible получает версии пакетов в формате json. Запускается скрипт compare/compare.py

4. Скрипт сравнивает версию пакета в current/{hostname}.json и в incoming/{hostname}.json. Если их нет, то файл в incoming удаляется, если измненения есть, то файл из incoming перезаписывает файл в current и удаляется. Изменение версии также отражается в логах сервера в каталоге history

## Запуск проекта

Склонируйте репозиторий и перейдите в директорию:

```
git clone https://github.com/ivonki/package-version-monitor
cd package-version-monitor
```

Создайте окружение для Python
```
python3 -m venv compare/venv
source compare/venv/bin/activate
pip install -r compare/requirements.txt
```

Заполните файл инвентаря inventory/hosts.ini в соответствии с вашими машинами, например:
```
[all]
server1 ansible_host=10.10.10.10 ansible_host=developer
```

Запуск скрипта (требуются права на исполнение)
```
chmod +x run.sh
./run.sh
```
Добавьте cron-задачу
```
export EDITOR=nano
crontab -e
*/10 * * * * cd *абсолютный путь к директории проекта* && ./run.sh >> *путь к директории проекта*/logs/cron.log 2>&1
```
