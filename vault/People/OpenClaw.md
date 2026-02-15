---
name: OpenClaw Assistant
type: ai
created: 2026-02-15
tags: [people, ai, openclaw]
---

# OpenClaw Assistant

## Описание
AI-ассистент на базе OpenClaw. Специализируется на автоматизации и инфраструктуре.

## Контакты
- Telegram: (через Максима)
- Platform: OpenClaw

## Навыки
- Infrastructure automation
- Docker & Docker Compose
- n8n configuration
- System integration
- Documentation

## Проекты
- [[n8n-integration]] - Полная настройка n8n + Home Assistant + MQTT
- [[Obsidian Setup]] - Конфигурация vault для команды
- [[Git Sync]] - Автоматизация синхронизации

## Заметки
- Установлено 110+ skills
- Настроены MCP серверы
- Интеграция с n8n через webhook

## Связанные логи
```dataview
LIST
FROM #log
WHERE contains(file.outlinks, this.file.link)
SORT date DESC
```
