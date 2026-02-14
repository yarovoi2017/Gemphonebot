# Obsidian Vault Git Sync & Collaboration

## Быстрый старт

### 1. Инициализация Git
```bash
~/.openclaw/workspace/scripts/vault-sync.sh init
```

### 2. Настройка remote (GitHub/GitLab)
```bash
# Создай репозиторий на GitHub/GitLab
# Скопируй URL
GIT_REMOTE=https://github.com/username/vault.git ~/.openclaw/workspace/scripts/vault-sync.sh remote
```

### 3. Первый commit и push
```bash
~/.openclaw/workspace/scripts/vault-sync.sh sync
```

### 4. Автосинхронизация
```bash
~/.openclaw/workspace/scripts/vault-sync.sh cron
```

## Работа с gemphonbot

### Инициализация совместной работы
```bash
~/.openclaw/workspace/scripts/vault-collab.sh init
```

### Отправить сообщение gemphone
```bash
~/.openclaw/workspace/scripts/vault-collab.sh msg "Привет! Готов к работе над n8n."
```

### Проверить сообщения от gemphone
```bash
~/.openclaw/workspace/scripts/vault-collab.sh check
```

### Создать общую задачу
```bash
~/.openclaw/workspace/scripts/vault-collab.sh task "Настроить webhook" "Нужен webhook для уведомлений из vault"
```

## Структура shared папки

```
~/vault/.shared/
├── README.md           # Правила совместной работы
├── jack/               # Сообщения от Jack для gemphone
│   ├── .archived/      # Архив прочитанных
├── gemphone/           # Сообщения от gemphone для Jack
│   └── .archived/      # Архив прочитанных
├── n8n/                # Конфигурации n8n
├── tasks/              # Общие задачи
└── status/             # Статусы агентов
```

## Автоматизация

### Cron (автосинк каждые 5 минут)
```bash
crontab -l | grep vault
# */5 * * * * ~/.openclaw/workspace/scripts/vault-sync.sh auto
```

### Webhook для n8n
```bash
# Установить URL
export N8N_WEBHOOK_URL=http://localhost:5678/webhook/vault-sync

# Sync с уведомлением
~/.openclaw/workspace/scripts/vault-sync.sh sync
```

## Разрешение конфликтов

При одновременном редактировании:
1. Git автоматически использует `theirs` strategy (чужие изменения приоритет)
2. Конфликты автоматически коммитятся с пометкой
3. Проверяй лог: `cd ~/vault && git log --oneline -10`

## Интеграция с n8n

### Workflow для n8n
```json
{
  "nodes": [
    {
      "parameters": {
        "path": "vault-sync",
        "responseMode": "responseNode"
      },
      "name": "Vault Webhook",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [250, 300]
    },
    {
      "parameters": {
        "chatId": "=YOUR_CHAT_ID",
        "text": "=Vault updated: {{$json.event}}"
      },
      "name": "Telegram Notification",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1,
      "position": [450, 300]
    }
  ]
}
```

## Команды

### vault-sync.sh
```bashnvault-sync.sh init       # Инициализация Git
vault-sync.sh remote     # Настройка remote
vault-sync.sh auto       # Автокоммит
vault-sync.sh push       # Push в remote
vault-sync.sh pull       # Pull из remote
vault-sync.sh sync       # Полный sync (commit+pull+push)
vault-sync.sh status     # Статус
vault-sync.sh cron       # Настройка автосинка
vault-sync.sh help       # Справка
```

### vault-collab.sh
```bash
vault-collab.sh init                    # Инициализация совместной работы
vault-collab.sh status                  # Статус коллаборации
vault-collab.sh msg "текст"             # Сообщение gemphone
vault-collab.sh check                   # Проверить сообщения
vault-collab.sh task "назв" "опис"      # Создать задачу
vault-collab.sh export                  # Экспорт системной инфы
vault-collab.sh help                    # Справка
```

## Безопасность

- 🔒 Git remote: HTTPS или SSH с ключом
- 🔐 Не коммитьить: `.env`, `secrets/`, `tokens/`
- 🔑 GitHub token: с минимальными правами (repo)
- 🛡️ Конфликты: автоматическое разрешение

## Troubleshooting

### Нет доступа к remote
```bash
# Для HTTPS: используй Personal Access Token
git remote set-url origin https://TOKEN@github.com/user/repo.git

# Для SSH: настрой ключи
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub  # Добавь в GitHub
```

### Конфликты при sync
```bash
cd ~/vault
git pull origin main --rebase -X theirs
```

### Не работает cron
```bash
pkg install cronie
# Или используй Termux:API для фоновых задач
```
