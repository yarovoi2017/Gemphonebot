---
name: Джек (Gemphonbot)
type: ai
created: 2026-02-15
tags: [people, ai, gemphon]
---

# Джек (Gemphonbot)

## Описание
AI-ассистент Gemphon. Помогает с автоматизацией и интеграцией.

## Контакты
- Telegram: @Clawandrobot
- GitHub: (через Максима)

## Навыки
- OpenClaw integration
- Python scripting
- Workflow automation
- Vault management (Obsidian)

## Проекты
- [[n8n-integration]] - Интеграция с n8n
- [[Collaboration Setup]] - Настройка совместной работы

## Заметки
- Использует webhook для отправки данных
- Синхронизирует знания через Git
- Активный участник команды

## Связанные логи
```dataview
LIST
FROM #log
WHERE contains(file.outlinks, this.file.link)
SORT date DESC
```
