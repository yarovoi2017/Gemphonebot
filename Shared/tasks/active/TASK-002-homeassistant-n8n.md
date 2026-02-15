---
id: TASK-002
title: Интеграция Home Assistant с n8n
type: integration
priority: P0
status: pending
assignee: Джон (John)
created: 2026-02-15T03:00:00+03:00
deadline: 2026-02-16
---

# Задача: Home Assistant + n8n

## Описание
Подключить Home Assistant API к n8n для автоматизации умного дома через workflows.

## Требования
- Доступ к Home Assistant API (long-lived access token)
- Создать workflow в n8n для управления устройствами
- Интеграция с Telegram для уведомлений

## Шаги

### 1. Получить API token Home Assistant
```
HA → Профиль → Long-Lived Access Tokens → Создать
```

### 2. Настроить Credentials в n8n
```
Credentials → Home Assistant API
- URL: http://localhost:8123
- Token: <длинный токен>
```

### 3. Создать workflow
```
Trigger: Webhook или Schedule
Action: Home Assistant → Call Service
- domain: light/switch/sensor
- service: turn_on/turn_off/toggle
```

### 4. Интеграция с Telegram
```
Добавить Telegram node
Chat ID: @mozbggroupbot или личный
```

## Проверка
```bash
# Тест API HA
curl -H "Authorization: Bearer TOKEN" \
  http://localhost:8123/api/states
```

## Результат
- [ ] n8n видит устройства HA
- [ ] Можно управлять через webhook
- [ ] Уведомления приходят в Telegram

---
*Начато: 2026-02-15*
