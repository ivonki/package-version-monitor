# Package Version Monitor

Система для сбора и отслеживания версий пакетов на удалённых Linux-хостах с использованием Ansible.

Проект автоматически фиксирует изменения версий и сохраняет историю обновлений.

---

## Архитектура

```text
package-version-monitor/
├── compare/
│   └── compare.py
├── data/
│   ├── current/
│   ├── history/
│   └── incoming/
├── inventory/
│   └── hosts.ini
├── playbooks/
├── scripts/
├── logs/
├── run.sh
├── install.sh
└── README.md
```

---

## Принцип работы

1. `install.sh` подготавливает окружение и зависимости
2. `run.sh` запускает процесс сбора и сравнения
3. Ansible выполняет `scripts/get_versions.sh` на удалённых хостах
4. Результат сохраняется в `data/incoming/`
5. `compare/compare.py`:
   - сравнивает `incoming/` и `current/`
   - обновляет `current/`
   - пишет изменения в `history/`
---

## Установка

```bash
git clone https://github.com/ivonki/package-version-monitor
cd package-version-monitor

bash install.sh
```

`install.sh` выполняет:
- проверку зависимостей (python3, ansible)
- подготовку окружения выполнения
- установку прав на скрипты

---

## Настройка inventory

Файл:

```
inventory/hosts.ini
```

Пример:

```ini
[all]
server1 ansible_host=10.10.10.10 ansible_user=developer
server2 ansible_host=10.10.10.11 ansible_user=developer
```

---

## Запуск

### Ручной запуск

```bash
./run.sh
```

## Формат данных

### data/incoming / data/current

```json
{
  "hostname": "server1",
  "packages": {
    "php": "8.1.0",
    "nginx": "1.22.0",
    "python": "3.10.6"
  }
}
```

---

### data/history

```text
[2026-01-23 02:00:01]
nginx: 1.18.0 -> 1.22.0
php: 7.4.0 -> 8.1.0
```

---

## Требования

### Управляющая машина (WSL)
- Python 3
- Ansible
- SSH доступ к хостам

### Удалённые машины
- bash
- стандартные системные утилиты (nginx, php, python и т.д.)
- Python не требуется

---

## Особенности

- agentless архитектура (без установки ПО на удалённые хосты)
- сбор через Ansible + SSH
- автоматическое сравнение версий
- хранение истории изменений
```