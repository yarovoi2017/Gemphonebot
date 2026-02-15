# 🤖 Интеграция: Obsidian + RAG + Lora + n8n

**Цель:** Общая база знаний между Джеком, мной и Лорой

---

## 🏗️ Архитектура системы

```
┌─────────────────────────────────────────────────────────────┐
│                     OBSIDIAN VAULT                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │  People  │  │ Topics   │  │  Daily   │  │  Shared  │    │
│  │ (профили)│  │ (знания) │  │ (логи)   │  │(общее)   │    │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘    │
│       └──────────────┴──────────────┴──────────────┘          │
│                      │                                        │
│              Git Sync (каждые 30 мин)                        │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                 POSTGRESQL / QDRANT                          │
│  ┌──────────────────┐      ┌──────────────────┐             │
│  │   RAG Database   │      │  Vector Storage  │             │
│  │ (текст + эмбеддинги) │  │  (768/1536 dim) │             │
│  └────────┬─────────┘      └────────┬─────────┘             │
└───────────┼────────────────────────┼────────────────────────┘
            │                        │
            ▼                        ▼
┌───────────────┐              ┌───────────────┐
│      LORA     │              │      n8n      │
│  (RAG Bot)    │              │ (Automation)  │
│               │              │               │
│ • Отвечает    │              │ • Индексирует │
│   на вопросы  │              │ • Синхронизует│
│ • Ищет в базе │              │ • Уведомляет  │
│ • Обучается   │              │ • Автоматизиру│
└───────────────┘              └───────────────┘
```

---

## 📁 Структура Obsidian для RAG

### Обновленная структура vault/
```
vault/
├── 📁 00-RAG-INDEX/           # Главный индекс для Лоры
│   ├── 📄 _index.md           # Корневой индекс знаний
│   ├── 📄 people-index.md     # Индекс людей
│   ├── 📄 topics-index.md      # Индекс тем
│   └── 📄 daily-index.md      # Индекс логов
│
├── 📁 People/                 # Профили (уже есть)
│   ├── 👤 Максим Яровой.md
│   ├── 👤 Джек.md
│   ├── 👤 OpenClaw.md
│   └── 👤 Лора.md             # Профиль Лоры
│
├── 📁 Topics/                 # База знаний (RAG)
│   ├── 🔧 n8n/
│   │   ├── n8n-setup.md
│   │   ├── workflows/
│   │   ├── credentials/
│   │   └── patterns.md        # Паттерны workflow
│   │
│   ├── 🏠 Home-Assistant/
│   │   ├── setup.md
│   │   ├── automations/
│   │   └── devices.md
│   │
│   ├── 💻 Infrastructure/
│   │   ├── docker/
│   │   ├── postgresql/
│   │   ├── networking/
│   │   └── monitoring/
│   │
│   └── 🤖 AI-ML/
│       ├── rag/
│       ├── llm/
│       ├── embeddings/
│       └── mcp/
│
├── 📁 Daily/                  # Логи разговоров (для RAG)
│   ├── 📄 log-2026-02-15.md
│   └── 📄 log-2026-02-16.md
│
├── 📁 Shared/                 # Общие ресурсы
│   ├── jack/
│   ├── openclaw/
│   └── lora/                  # Вклад Лоры
│
└── 📁 _embeddings/            # Векторные эмбеддинги
    ├── people.vectors.json
    ├── topics.vectors.json
    └── daily.vectors.json
```

---

## 🔗 Ключевые связи (Backlinks)

### Для RAG:
Каждая заметка должна иметь:

```markdown
## Метаданные RAG
- **Тип:** [person/topic/log/decision]
- **Теги:** #rag #n8n #infrastructure
- **Автор:** Джек
- **Дата:** 2026-02-15
- **Статус:** [активно/архив]
- **Лора-ready:** ✅

## Ссылки
- [[00-RAG-INDEX]]
- [[Максим Яровой]]
- [[n8n-setup]]
- [[2026-02-15]]

## Векторный индекс
- **Embedding-model:** text-embedding-3-large
- **Vector-size:** 3072
- **Last-indexed:** 2026-02-15

---

## Содержимое
# Заголовок

Текст для RAG...

## Решения
- [x] Выбрали PostgreSQL

## Следующие шаги
- [ ] Настроить Qdrant
```

---

## ⚡ n8n Workflow для RAG

### Workflow 1: RAG Index Builder
```yaml
Trigger: Git push to vault/
  ↓
Action: Parse markdown files
  ↓
Action: Generate embeddings (OpenRouter)
  ↓
Action: Store in PostgreSQL
  ↓
Action: Update Qdrant vectors
  ↓
Notify: "RAG index updated: X files"
```

### Workflow 2: Lora Knowledge Sync
```yaml
Trigger: Daily at 2 AM
  ↓
Query: Recent changes in vault/
  ↓
Action: Extract new knowledge
  ↓
Action: Update Lora context
  ↓
Notify: Telegram "Lora synced: X topics"
```

### Workflow 3: Smart Search API
```yaml
Webhook: /api/search
  ↓
Query: PostgreSQL vectors
  ↓
Response: Top 5 relevant docs
```

---

## 🧠 Процесс для Лоры

### Как Лора использует базу:

1. **Вопрос приходит** → Лора ищет в Qdrant
2. **Найдены документы** → Ранжирование по similarity
3. **Формируется контекст** → Топ-3 релевантных заметки
4. **Ответ генерируется** → С учетом знаний из vault

### Пример:
```
Вопрос: "Как настроить webhook в n8n?"

Лора ищет → Находит:
1. Topics/n8n/workflows/patterns.md (similarity: 0.92)
2. Shared/jack/session-summary-2026-02-14.md (0.87)
3. Daily/log-2026-02-15.md (0.85)

Контекст: Джек уже настраивал webhook...
Ответ: "Согласно документации Джека, нужно..."
```

---

## 📝 Теговая система для RAG

```
#rag          # Главный тег для индексации
#person        # Профили людей
#topic         # Тематические заметки
#log          # Логи разговоров
#decision     # Принятые решения
#todo         # Задачи
#pattern      # Паттерны/шаблоны
#troubleshoot # Решение проблем

#priority/high    # Высокий приоритет
#priority/medium  # Средний
#priority/low     # Низкий

#status/active    # Активно
#status/wip       # В работе
#status/done      # Готово
#status/archive   # Архив
```

---

## 🚀 Быстрый старт для Джека

### 1. Создать Лоре профиль
```markdown
# Лора (RAG Assistant)

## Описание
AI-ассистент с RAG. Отвечает на вопросы используя Obsidian vault.

## Навыки
- Поиск в базе знаний
- Генерация ответов с контекстом
- Обучение на новых данных

## Доступ
- Qdrant: localhost:6333
- PostgreSQL: localhost:5432
- API: http://localhost:5678/webhook/lora-query

## Стиль общения
Технический, краткий, со ссылками на источники.
```

### 2. Индексировать текущие заметки
```bash
# Запустить индексацию
python scripts/index_vault_for_rag.py
```

### 3. Тест Лоры
```bash
# Запрос к Лоре
curl -X POST http://localhost:5678/webhook/lora-query \
  -d '{"question":"Какие workflow настроены?"}'
```

---

*Интеграция Obsidian ↔ RAG ↔ Lora готова к работе!* 🧠
