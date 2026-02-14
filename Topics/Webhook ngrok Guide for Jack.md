# Webhook через ngrok - Инструкция для Джека

## Что такое ngrok?
ngrok создаёт временный публичный URL для локального сервера.

## Как это работает:
```
Джек (телефон/POCO) → Интернет → ngrok Cloud → ПК Джона (n8n)
                              ↓
                    https://xxx.ngrok-free.app
```

## Текущий URL (обновляется при перезапуске)

**Файл с актуальным URL:**
`C:\Users\mozbg\.openclaw\ngrok-url.txt`

**Webhook endpoint:**
```
https://<ngrok-id>.ngrok-free.app/webhook/jack-notify
```

## Примеры запросов от Джека:

### 1. Новая задача
```bash
curl -X POST https://xxx.ngrok-free.app/webhook/jack-notify \
  -H "Content-Type: application/json" \
  -d '{
    "agent": "jack",
    "event": "task_created",
    "data": {
      "title": "Настроить PostgreSQL",
      "priority": "high",
      "description": "Нужна база для RAG системы"
    }
  }'
```

### 2. Запрос секрета
```bash
curl -X POST https://xxx.ngrok-free.app/webhook/jack-notify \
  -H "Content-Type: application/json" \
  -d '{
    "agent": "jack",
    "event": "secret_request",
    "data": {
      "secret_name": "GitHub Token",
      "reason": "Для автосинхронизации vault"
    }
  }'
```

### 3. Статус обновления
```bash
curl -X POST https://xxx.ngrok-free.app/webhook/jack-notify \
  -H "Content-Type: application/json" \
  -d '{
    "agent": "jack",
    "event": "status_update",
    "data": {
      "message": "Tailscale установлен на POCO"
    }
  }'
```

## События (events):
- `task_created` — новая задача
- `task_completed` — задача выполнена
- `secret_request` — запрос секрета
- `help_needed` — нужна помощь
- `status_update` — статус
- `vault_updated` — обновление vault

## Важно:
- ⚠️ URL меняется при каждом перезапуске ngrok
- ⏰ Проверяйте актуальный URL перед отправкой
- 🔒 Используйте HTTPS (шифрование)
- 📱 Работает с телефона через мобильный интернет

## Получить актуальный URL:
Джон будет сообщать новый URL после перезапуска, или проверяйте:
https://github.com/yarovoi2017/Gemphonebot/blob/main/ngrok-url.txt
