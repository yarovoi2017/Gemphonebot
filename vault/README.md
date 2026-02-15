# 🚀 Проект: Интеграция n8n + Home Assistant + Team Collaboration

**Статус:** ✅ Активен  
**Дата начала:** 15 февраля 2026  
**Участники:** Максим, Джек, OpenClaw

---

## 📋 Описание

Полная инфраструктура автоматизации для команды:
- Автоматизация workflow (n8n)
- Умный дом (Home Assistant)
- Общая база знаний (Obsidian + Git)
- Уведомления (Telegram)

---

## 🏗️ Компоненты

### Развернутые сервисы
| Сервис | URL | Статус |
|--------|-----|--------|
| n8n | http://localhost:5678 | ✅ Работает |
| Home Assistant | http://localhost:8123 | ✅ Работает |
| Mosquitto MQTT | localhost:1883 | ✅ Работает |

### Workflow (n8n)
| Название | ID | Назначение | Статус |
|----------|-----|------------|--------|
| Jack Notifications | 2aEsr2VBruOWW095 | Webhook для Джека | ✅ Active |
| OpenClaw Notifications | ERQSEYKXKL38iF8T | Webhook для OpenClaw | ✅ Active |
| Git Vault Sync | 8qIOleFeDy61SRyA | Автосинхронизация | ⏳ Pending |
| Conversation Logger | Waf9SKxtZM3lnl2C | Логирование | ⏳ Pending |

---

## 📁 Структура Проекта

```
vault/
├── 📄 README.md                    # Этот файл
├── 📄 COLLABORATION_GUIDE.md       # Руководство по совместной работе
├── 📄 OBSIDIAN_SETUP.md            # Настройка Obsidian
│
├── 👥 People/                      # Профили участников
│   ├── Максим Яровой.md
│   ├── Джек (Gemphonbot).md
│   └── OpenClaw.md
│
├── 📚 Topics/                      # Базы знаний
│   ├── n8n/
│   ├── Home Assistant/
│   └── RAG/
│
├── 📤 Shared/                      # Общие ресурсы
│   ├── jack/
│   └── openclaw/
│
└── 📅 Daily/                       # Ежедневные логи
```

---

## 🚀 Быстрый старт

### Для Максима
```bash
# Просмотр статуса
docker ps

# Ручная синхронизация vault
cd vault && git add . && git commit -m "Update" && git push

# Открыть n8n
start http://localhost:5678
```

### Для Джека
```bash
# Отправить webhook
curl -X POST https://unoxidated-ian-nonrepressibly.ngrok-free.dev/webhook/jack-notify \
  -H "Content-Type: application/json" \
  -d '{"event":"task","data":{"message":"Новая задача"}}'

# Логировать разговор
curl -X POST https://unoxidated-ian-nonrepressibly.ngrok-free.dev/webhook/log-conversation \
  -H "Content-Type: application/json" \
  -d '{"agent":"jack","message":"Сообщение","context":{"topic":"test"}}'
```

### Для OpenClaw
```bash
# Тест webhook
curl -X POST http://localhost:5678/webhook/openclaw-notify \
  -H "Content-Type: application/json" \
  -d '{"message":"Тест","priority":"normal"}'
```

---

## 📊 Статистика

- **Продолжительность:** 10+ часов
- **Workflow создано:** 4
- **Тестов пройдено:** 8/8 ✅
- **Документация:** 5 файлов

---

## 📝 Лог изменений

### 2026-02-15
- ✅ Развернут Docker стек (n8n, HA, MQTT)
- ✅ Созданы workflow для Джека и OpenClaw
- ✅ Настроен Telegram бот
- ✅ Создана структура vault
- ✅ Настроен MCP server

---

## 🔗 Полезные ссылки

- [Collaboration Guide](./Shared/COLLABORATION_GUIDE.md)
- [Obsidian Setup](./Shared/OBSIDIAN_SETUP.md)
- [GitHub Repository](https://github.com/yarovoi2017/Gemphonebot)

---

*Проект для совместной работы Максима, Джека и OpenClaw*
