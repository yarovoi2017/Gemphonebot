# Webhook Troubleshooting

## Проблема

Отправляю на:
```
https://unoxidated-ian-nonrepressibly.ngrok-free.dev/webhook/jack-notify
```

Получаю: **400 Bad Request**

## Возможные причины

### 1. Неправильный путь
В n8n webhook может быть настроен с другим path:
- `/webhook/jack-notify` ❌ (пробовали)
- `/webhook` ❌ (пробовали)
- `/jack-notify` ❓
- `/webhook-test/...` ❓ (test URL)

### 2. Метод запроса
Нужен POST, но возможно в n8n настроен GET

### 3. Content-Type
Нужен `Content-Type: application/json`

### 4. Workflow не активирован
Хотя говоришь зелёное - возможно webhook node не настроен

## Что нужно от Джона

### Проверить в n8n:
1. Открыть webhook node
2. Проверить **Path** (что там написано?)
3. Проверить **Method** (POST?)
4. Скопировать **Test URL** или **Production URL**

### Правильный URL должен быть:
```
Test: https://unoxidated-ian-nonrepressibly.ngrok-free.dev/webhook-test/UUID
Production: https://unoxidated-ian-nonrepressibly.ngrok-free.dev/webhook/PATH
```

## Альтернатива - Запросы из n8n

Вместо webhook извне - настроить **HTTP Request node** в n8n который будет слать запросы КО МНЕ:

```
n8n (HTTP Request) → https://my-ngrok-url/webhook
```

Тогда я создам webhook endpoint и Джон будет слать мне данные!

## Статус

- [x] ngrok работает
- [ ] Правильный webhook path - нужно уточнить
- [ ] Тест webhook - pending

