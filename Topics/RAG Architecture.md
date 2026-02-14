---
created: 2026-02-14
updated: 2026-02-14
tags: [topic]
---

# RAG Architecture

RAG (Retrieval-Augmented Generation) архитектура для OpenClaw:\n\n## Компоненты\n1. **Obsidian Vault** — основное хранилище (markdown, человекочитаемо)\n2. **PostgreSQL + pgvector** — структурированные данные и SQL поиск\n3. **Qdrant** — векторная база для семантического поиска\n4. **ChromaDB** — альтернативная векторная база\n5. **Sync layer** — синхронизация Obsidian ↔ Базы\n\n## Поток данных\nObsidian (markdown) → Парсинг → Базы (индексы) → AI запрос → Релевантные заметки → Ответ\n\n## Преимущества\n- Данные всегда читаемы (plain markdown)\n- Быстрый векторный поиск\n- Надёжное хранение в PostgreSQL\n- Масштабируемость через Docker

## История
- 2026-02-14: Создано

