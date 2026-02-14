# MCP для n8n

## Конфигурация создана

### Файлы:
- `~/.openclaw/mcp-n8n.json` — конфигурация MCP
- `~/.openclaw/workspace/scripts/mcp-n8n-server.py` — MCP сервер

### Запуск MCP сервера:
```bash
python3 ~/.openclaw/workspace/scripts/mcp-n8n-server.py
# Запускается на http://127.0.0.1:8765
```

### Инструменты MCP:
1. **n8n_webhook** — отправить webhook в n8n
2. **n8n_get_workflows** — список workflows

### Тест через MCP:
```bash
curl -X POST http://127.0.0.1:8765 \
  -H "Content-Type: application/json" \
  -d '{
    "method": "tools/call",
    "params": {
      "name": "n8n_webhook",
      "arguments": {
        "workflow": "jack-notify",
        "data": {"event": "test", "message": "Hello!"}
      }
    }
  }'
```

## Но проще напрямую:

### Webhook (работает когда активирован):
```bash
curl -X POST https://unoxidated-ian-nonrepressibly.ngrok-free.dev/webhook/jack-notify \
  -H "Content-Type: application/json" \
  -d '{"event":"test","data":{"message":"Привет!"}}'
```

### Или через HTTP Request в n8n:
```javascript
// HTTP Request node
Method: POST
URL: https://unoxidated-ian-nonrepressibly.ngrok-free.dev/webhook/jack-notify
Body: {"agent":"jack","event":"test"}
```

## Статус

- [x] MCP конфигурация
- [x] MCP сервер
- [ ] Тест (ждём активации workflow в n8n)

## Рекомендация

MCP хорош для стандартизации, но для n8n проще использовать **прямые HTTP webhook вызовы** — меньше точек отказа.

**Оба варианта работают после активации workflow!** 🚀
