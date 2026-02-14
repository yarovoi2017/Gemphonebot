# KeePass + n8n Интеграция

## Цель
Безопасный обмен секретами между Максимом и Gemphonbot через KeePass + n8n

## Архитектура

### У Максима (Windows)
- **KeePass 2** — локальное хранилище секретов
- **Плагин KeePassHTTP** или **KeePassXC-Browser** — для интеграции
- **Общая база** — синхронизируется через GitHub/Git

### У Gemphonbot (n8n)
- **Чтение секретов** — из KeePass через API
- **Webhook** — уведомления об изменениях
- **Запись** — новые секреты от бота

## Настройка

### Шаг 1: Установка KeePass
```powershell
# Скачать KeePass 2
# https://keepass.info/download.html

# Или через winget
winget install DominikReichl.KeePass
```

### Шаг 2: Создание общей базы
1. Создайте базу: `File → New`
2. Место: `%USERPROFILE%\.openclaw\vault\Secrets.kdbx`
3. Мастер-пароль: придумайте сложный!
4. Добавьте группы:
   - 🔑 API Keys
   - 🔒 Passwords
   - 🌐 Webhooks
   - 🤖 Bot Tokens

### Шаг 3: Структура записей
```
Secrets.kdbx
├── 🔑 API Keys
│   ├── GitHub Token (yarovoi2017)
│   ├── Telegram Bot Token (OpenClaw)
│   └── n8n API Key
├── 🔒 Passwords
│   └── Shared Service Passwords
├── 🌐 Webhooks
│   ├── Gemphonbot Webhook URL
│   └── n8n Webhook URL
└── 🤖 Bot Tokens
    ├── @MaximYarovoi
    └── @Gemphonbot
```

### Шаг 4: Синхронизация базы
```powershell
# Добавить в .gitignore (не коммитить базу!)
echo "*.kdbx" >> C:\Users\mozbg\.openclaw\vault\.gitignore
echo "*.key" >> C:\Users\mozbg\.openclaw\vault\.gitignore

# Синхронизировать через другой канал:
# - Google Drive
# - Dropbox
# - Syncthing
# - Ручная передача
```

## n8n Workflow для KeePass

### Workflow 1: Чтение секретов
```json
{
  "name": "KeePass Secret Reader",
  "trigger": {
    "type": "webhook",
    "path": "/keepass/read"
  },
  "nodes": [
    {
      "type": "keepass",
      "operation": "read",
      "database": "/data/Secrets.kdbx",
      "key": "{{ $env.KEEPASS_KEY }}"
    }
  ]
}
```

### Workflow 2: Запись секрета
```json
{
  "name": "KeePass Secret Writer",
  "trigger": {
    "type": "webhook",
    "path": "/keepass/write"
  },
  "nodes": [
    {
      "type": "keepass",
      "operation": "write",
      "database": "/data/Secrets.kdbx",
      "entry": {
        "title": "{{ $json.title }}",
        "username": "{{ $json.username }}",
        "password": "{{ $json.password }}",
        "group": "{{ $json.group }}"
      }
    }
  ]
}
```

## Безопасность

### Правила
1. **База не в Git** — никогда не коммитить `*.kdbx`
2. **Мастер-пароль** — только у Максима
3. **Ключевой файл** — хранить отдельно
4. **Резервные копии** — регулярно

### Передача секретов Gemphonbot
```
Вариант 1: Через n8n (безопасно)
1. Gemphonbot запрашивает секрет через webhook
2. n8n читает из KeePass
3. n8n отправляет в зашифрованном виде
4. Автоматически удаляется через 5 минут

Вариант 2: Через Telegram (временно)
1. Секрет разбивается на части
2. Отправляется в разных сообщениях
3. Удаляется через 1 минуту
4. Gemphonbot собирает и сохраняет
```

## Автоматизация

### Скрипт синхронизации
```bash
#!/bin/bash
# sync-keepass.sh

# Путь к базе
DB="$HOME/.openclaw/vault/Secrets.kdbx"
BACKUP="$HOME/.openclaw/vault/backups/"

# Резервная копия
cp "$DB" "$BACKUP/Secrets-$(date +%Y%m%d-%H%M%S).kdbx"

# Синхронизация (если используете облако)
# rclone sync "$DB" remote:keepass/

echo "KeePass synced at $(date)"
```

## Практическое использование

### Добавить новый API ключ
1. Открыть KeePass
2. Создать запись в группе "🔑 API Keys"
3. Название: `GitHub Token - Gemphonbot`
4. Логин: `token`
5. Пароль: [вставить токен]
6. URL: `https://github.com/settings/tokens`
7. Сохранить

### Gemphonbot получает секрет
```
Gemphonbot: "Нужен GitHub токен для n8n"
    ↓
n8n: Читает из KeePass
    ↓
n8n: Отправляет Gemphonbot (временно)
    ↓
Gemphonbot: Сохраняет в своё хранилище
```

## Документация
- [KeePass](https://keepass.info/help/base/index.html)
- [KeePassHTTP](https://github.com/pfn/keepasshttp)
- [n8n KeePass node](https://n8n.io/integrations/keepass/)

---
*Этот файл — инструкция. Сама база Secrets.kdbx не коммитится!*
