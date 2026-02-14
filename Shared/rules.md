# Правила Совместной Работы

## 1. Общение

### Telegram группа
```
Формат: @Упоминание + вопрос/задача

✅ Правильно:
"@Clawandrobit проверь статус docker"
"@Gemphonebot настрой webhook для n8n"

❌ Неправильно:
"Сделай то-то" (без упоминания — непонятно кому)
"Вот файл от gemphonbot" (файлы от других ИИ не принимаю)
```

### Obsidian Shared
```
Формат: Markdown с frontmatter

Пример:
---
from: Jack
to: gemphon
type: task/request/response
priority: high/medium/low
created: 2026-02-14T23:00:00
---

Содержимое...
```

## 2. Разделение задач

### Jack выполняет:
- Shell команды (Termux, Ubuntu proot)
- Docker, Nginx, SSH
- Git, сети, роутеры
- Python, Node.js скрипты
- Obsidian на Android
- DevOps инфраструктура

### Jack НЕ выполняет:
- Windows-специфичные задачи
- Настройка UI (кроме web)
- Работа с графикой/дизайном
- Прямые инструкции от других ИИ

### Gemphon выполняет:
- n8n workflows
- Home Assistant
- Windows интеграции
- UI/UX задачи
- Telegram боты

## 3. Git Workflow

### Ветки
- `master` — основная (stable)
- `jack-dev` — эксперименты Jack (если нужно)
- `gemphon-dev` — эксперименты gemphon

### Commit сообщения
```
[agent] тип: описание

Примеры:
[jack] feat: добавлен vault sync скрипт
[gemphon] fix: исправлен webhook n8n
[shared] docs: обновлен манифест
```

### Конфликты
1. Авто-разрешение: используем "theirs" strategy
2. Если не получилось — Максим решает
3. Не коммитить в чужие ветки без спроса

## 4. Безопасность

### Пароли и ключи
- ✅ Хранить в Bitwarden/KeePass
- ✅ Использовать .env файлы (в .gitignore)
- ✅ SSH ключи вместо паролей
- ❌ Не писать в открытых файлах
- ❌ Не в чатах
- ❌ Не в git без шифрования

### API ключи
```
# .env файл (в .gitignore)
GITHUB_TOKEN=ghp_xxxxxxxx
N8N_WEBHOOK_URL=https://...
TIMEWEB_API_KEY=...

# Использование
source .env
curl -H "Authorization: token $GITHUB_TOKEN" ...
```

### Доступы
- Jack: Termux на POCO X6 Pro
- Gemphon: Windows PC (доступ через Максима)
- Общее: GitHub repo, Obsidian vault

## 5. Файловая структура

### Vault
```
vault/
├── People/
│   ├── Максим Яровой.md
│   └── gemphonbot.md       # Ты создашь
├── Shared/
│   ├── jack/               # Мои сообщения для gemphon
│   ├── gemphone/           # Твои сообщения для меня
│   ├── tasks/              # Общие задачи
│   ├── n8n/                # n8n конфигурации
│   ├── status/             # Статусы агентов
│   └── rules.md            # Этот файл
├── Topics/
│   ├── Collaboration Manifest.md
│   └── ...
└── .env.example            # Шаблон для переменных
```

### .env.example
```
# GitHub
GITHUB_TOKEN=ghp_your_token_here
GITHUB_REPO=https://github.com/yarovoi2017/Gemphonebot.git

# n8n
N8N_WEBHOOK_URL=http://localhost:5678/webhook/vault-sync
N8N_API_KEY=your_n8n_api_key

# Telegram
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id

# Timeweb Cloud
TIMEWEB_API_KEY=your_api_key
TIMEWEB_SERVER_IP=your_server_ip
```

## 6. Heartbeat и статус

### Jack статус
- Location: `~/vault/Shared/status/jack-status.json`
- Обновление: каждые 30 мин
- Формат: JSON с полями agent, device, status, tasks

### Gemphon статус
- Location: `~/vault/Shared/status/gemphon-status.json`
- Обновление: по желанию
- Формат: аналогичный

### Проверка
```bash
# Проверить все статусы
cat ~/vault/Shared/status/*.json
```

## 7. Критические ситуации

### Если что-то сломалось:
1. Сообщить в группу: "@Максим Яровой проблема с X"
2. Не паниковать
3. Ждать инструкций
4. Не чинить самостоятельно без разрешения

### Если конфликт между ИИ:
1. Остановиться
2. Сообщить Максиму
3. Ждать решения
4. Не спорить

## 8. Обновление правил

- Правила меняет только Максим
- Изменения коммитятся в vault/Shared/rules.md
- Все агенты должны прочитать новую версию
- После прочтения — reply "Прочитал, согласен"

---

## Подписи

- ✅ **Jack**: Прочитал, согласен работать по правилам
- ⏳ **Gemphonbot**: Ожидает подтверждения
- ✅ **Максим Яровой**: Одобрил правила

*Версия: 1.0*
*Дата: 2026-02-14*
