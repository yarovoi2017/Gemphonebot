# RAG Database Stack в Ubuntu (POCO X6 Pro)

## Что будем устанавливать

1. **PostgreSQL + pgvector** — реляционная БД с векторным поиском
2. **Qdrant** — векторная база данных
3. **ChromaDB** — ещё одна векторная БД
4. **Adminer** — веб-интерфейс для PostgreSQL

## Подготовка

```bash
# Войти в Ubuntu
ubuntu

# Создать директорию
mkdir -p ~/rag-stack && cd ~/rag-stack
```

## Docker Compose конфигурация

Создай файл `docker-compose.yml`:

```yaml
version: '3.8'

services:
  postgres:
    image: ankane/pgvector:latest
    container_name: rag_postgres
    environment:
      POSTGRES_USER: maxim
      POSTGRES_PASSWORD: maxim123
      POSTGRES_DB: memory
    ports:
      - "5432:5432"
    volumes:
      - ./postgres:/var/lib/postgresql/data
    command: postgres -c shared_preload_libraries=vectors.so

  qdrant:
    image: qdrant/qdrant:latest
    container_name: rag_qdrant
    ports:
      - "6333:6333"
    volumes:
      - ./qdrant:/qdrant/storage

  chromadb:
    image: chromadb/chroma:latest
    container_name: rag_chromadb
    ports:
      - "8000:8000"
    volumes:
      - ./chromadb:/chroma/chroma
    environment:
      - IS_PERSISTENT=TRUE

  adminer:
    image: adminer:latest
    container_name: rag_adminer
    ports:
      - "8080:8080"
```

## Запуск

```bash
# Запустить все сервисы
docker-compose up -d

# Проверить статус
docker-compose ps

# Логи
docker-compose logs -f postgres
```

## Доступ

| Сервис | URL | Описание |
|--------|-----|----------|
| PostgreSQL | `localhost:5432` | База данных |
| Qdrant | `localhost:6333` | Векторная БД |
| ChromaDB | `localhost:8000` | Векторная БД |
| Adminer | `localhost:8080` | Веб-интерфейс PostgreSQL |

## Подключение к PostgreSQL

```bash
# Из Ubuntu
psql -h localhost -U maxim -d memory

# Пароль: maxim123
```

## SQL для инициализации

```sql
-- Включить pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- Таблица разговоров
CREATE TABLE conversations (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    message TEXT,
    embedding vector(1536),
    metadata JSONB
);

-- Таблица фактов
CREATE TABLE user_facts (
    id SERIAL PRIMARY KEY,
    category VARCHAR(50),
    key VARCHAR(200),
    value TEXT,
    embedding vector(1536)
);

-- Индекс для векторного поиска
CREATE INDEX ON conversations USING ivfflat (embedding vector_cosine_ops);
```

## Интеграция с Obsidian

### Вариант 1: PostgreSQL как backend

```python
# Скрипт для синхронизации Obsidian ↔ PostgreSQL
import psycopg2
import frontmatter
from pathlib import Path

vault_path = Path.home() / "vault"

# Подключение
conn = psycopg2.connect(
    host="localhost",
    database="memory",
    user="maxim",
    password="maxim123"
)

# Чтение markdown файлов
for md_file in vault_path.rglob("*.md"):
    post = frontmatter.load(md_file)
    
    # Сохранить в БД
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO conversations (date, message, metadata) VALUES (%s, %s, %s)",
            (post.metadata.get('date'), post.content, post.metadata)
        )
    conn.commit()
```

### Вариант 2: ChromaDB для RAG

```python
import chromadb

client = chromadb.HttpClient(host="localhost", port=8000)

# Создать коллекцию
collection = client.create_collection("obsidian_notes")

# Добавить заметки из vault
for note in vault_notes:
    collection.add(
        documents=[note.content],
        metadatas=[note.metadata],
        ids=[note.filename]
    )

# Поиск
results = collection.query(
    query_texts=["Проекты Максима"],
    n_results=5
)
```

## Структура данных

### Человекочитаемый формат

**Obsidian остаётся основным хранилищем** — markdown файлы:
- Простые для чтения
- Переносимые
- Версионируемые через git

**Базы данных** — индексы для быстрого поиска:
- PostgreSQL: структурированные данные, SQL
- Qdrant/ChromaDB: векторный поиск по смыслу

### Синхронизация

```
Obsidian Vault
     ↓ (экспорт)
Markdown файлы
     ↓ (парсинг)
Базы данных (индексы)
     ↓ (поиск)
Релевантные заметки → AI ответ
```

## Использование из OpenClaw

```python
# Поиск в памяти
memory_search("Какой у Максима роутер?")

# Результат:
# 1. Найти векторное представление запроса
# 2. Запрос к ChromaDB/PostgreSQL
# 3. Получить релевантные заметки из Obsidian
# 4. Сформировать ответ
```

## Бэкапы

```bash
# Бэкап PostgreSQL
docker exec rag_postgres pg_dump -U maxim memory > backup.sql

# Бэкап Qdrant
tar -czf qdrant-backup.tar.gz ./qdrant

# Бэкап Obsidian vault
tar -czf vault-backup.tar.gz ~/vault
```

## Восстановление

```bash
# PostgreSQL
docker exec -i rag_postgres psql -U maxim memory < backup.sql

# Распаковка Qdrant
tar -xzf qdrant-backup.tar.gz

# Распаковка vault
tar -xzf vault-backup.tar.gz -C ~/
```

## Преимущества схемы

1. **Человекочитаемо** — Obsidian это просто markdown
2. **Быстрый поиск** — векторные БД для семантического поиска
3. **Надёжно** — PostgreSQL для структурированных данных
4. **Масштабируемо** — Docker контейнеры легко масштабировать

## Следующие шаги

1. Запустить `docker-compose up -d` в Ubuntu
2. Создать таблицы в PostgreSQL
3. Настроить синхронизацию Obsidian ↔ Базы
4. Интегрировать с OpenClaw

## Команды управления

```bash
# Запуск
cd ~/rag-stack && docker-compose up -d

# Остановка
docker-compose down

# Перезапуск
docker-compose restart

# Обновление образов
docker-compose pull && docker-compose up -d
```
