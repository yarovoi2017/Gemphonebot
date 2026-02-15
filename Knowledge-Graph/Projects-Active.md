---
tags: [projects, active, tasks, dacha, automation]
---

# 🎯 Projects: Активные проекты

> Текущие задачи и цели из GPT-диалогов

---

## 📋 Project Dashboard

```mermaid
timeline
    title Таймлайн активных проектов
    section ГОТОВО ✅
      Obsidian sync : Джек : 2026-02
      GPT parsing   : Джек : 2026-02
      Knowledge Graph : Джек : 2026-02
    section В ПРОЦЕССЕ 🟡
      VDS self-hosting : Джек + Джон : 2026-02
      Home Assistant   : Джек + Джон : 2026-02
      n8n webhook      : Джон : 2026-02
    section ЗАБЛОКИРОВАН ⏳
      Mikrotik setup   : USB-C adapter
      RAG integration  : Ждет базы
```

---

## Пространство проектов (Mind Map)

```mermaid
mindmap
  root((ПРОЕКТЫ<br/>Максима))
    ДОМ 🏠
      Переезд дачу
      Новая инфраструктура
      Микротик настройка
      Сеть и VPN
    СЕРВЕР 🌍
      VDS Docker
      n8n автоматизация
      Webmin админка
      VPN VLESS
    AI 🤖
      Джек + Джон
      Мультиагенты
      Telegram боты
      OpenClaw навыки
    ДАННЫЕ 💾
      Obsidian vault
      GPT история
      Knowledge Graph
      Git sync
    ОБУЧЕНИЕ 📚
      Промпт-инжиниринг
      Zerocoder
      Linux команды
      Автоматизация
```

---

## 🏠 PROJECT-001: Переезд на дачу

```mermaid
graph LR
    subgraph BEFORE["🏙️ БЫЛО: Квартира"]
        B1[LTE модем]
        B2[Mikrotik<br/>176.12.97.99]
        B3[Asus T300LA]
    end
    
    subgraph NOW["🏡 СТАЛО: Дача"]
        N1[Новый провайдер<br/>?]
        N2[Новая сеть<br/>?]
        N3[POCO X6<br/>центр]
    end
    
    subgraph CHALLENGES["⚠️ ЗАДАЧИ:"]
        C1[Интернет на даче]
        C2[Роутер/сеть]
        C3[Доступ к квартире]
        C4[Mikrotik/перенос?]
    end
    
    BEFORE -->|переезд| NOW
    NOW --> CHALLENGES
```

**Статус:** 🟡 В процессе  
**Приоритет:** ВЫСОКИЙ  
**Блокеры:** Неизвестна инфраструктура

**Задачи:**
- [ ] Определить интернет-провайдера
- [ ] Настроить локальную сеть
- [ ] Решить судьбу Mikrotik
- [ ] Организовать доступ к квартире

**Связи:**
- [[Tech-Cluster]] → Сетевые технологии
- [[Personal/2025-01-01_67745b75]] → Cloudflare настройки

---

## 🌍 PROJECT-002: VDS Self-Hosting Stack

```mermaid
graph TB
    subgraph VDS["🌍 VDS Нидерланды"]
        subgraph DOCKER["🐳 Docker Compose"]
            D1[Nginx Proxy Manager]
            D2[n8n]
            D3[Portainer]
            D4[Home Assistant*]
            D5[Webmin*]
            D6[3x-ui VPN]
        end
    end
    
    subgraph DOMAINS["🌐 yarovoihub.tech"]
        Y1[homesrv → Docker]
        Y2[npm → NPM]
        Y3[n8n → N8N]
        Y4[portainer → Portainer]
        Y5[webmin → Webmin]
        Y6[3x-ui → VPN]
    end
    
    subgraph ACCESS["📱 Доступ с POCO"]
        A1[Termux SSH]
        A2[Termius]
        A3[Browser HTTPS]
    end
    
    VDS -->|DNS| DOMAINS
    DOCKER -->|expose| Y1
    DOCKER -->|expose| Y2
    DOCKER -->|expose| Y3
    DOCKER -->|expose| Y4
    DOCKER -->|expose| Y5
    DOCKER -->|expose| Y6
    
    DOMAINS -->|через| ACCESS
```

**Статус:** 🟡 В процессе  
**Приоритет:** ВЫСОКИЙ

**Уже работает:**
- ✅ Docker установлен
- ✅ Nginx Proxy Manager
- ✅ Домены настроены

**В процессе:**
- 🟡 n8n workflows
- 🟡 Home Assistant
- 🟡 VPN 3x-ui

**Связи:**
- [[Tech-Cluster]] → Self-Hosting философия
- [[../../Projects/RAG-GPT-Integration/README]] → Базы данных

---

## 🤖 PROJECT-003: Multi-Agent System

```mermaid
flowchart TB
    subgraph USERS["👤 Пользователи"]
        U1[Максим]
        U2[Александр?]
    end
    
    subgraph AGENTS["🤖 Агенты"]
        A1[Джек<br/>Android POCO<br/>OpenClaw]
        A2[Джон<br/>Windows PC<br/>n8n]
        A3[?]<br/>Future]
    end
    
    subgraph INTERFACE["💬 Интерфейс"]
        I1[Telegram]
        I2[Obsidian Shared]
        I3[n8n Webhooks]
    end
    
    subgraph BACKEND["⚙️ Backend"]
        B1[VDS Docker]
        B2[GitHub Sync]
        B3[LLM APIs]
    end
    
    USERS -->|управляет| AGENTS
    AGENTS -->|общаются через| INTERFACE
    AGENTS -->|используют| BACKEND
    
    A1 <-->|Obsidian| I2
    A2 <-->|Telegram| I1
    A1 <-->|Webhook| I3
    A2 <-->|Webhook| I3
    
    I2 -->|Git| B2
    I3 -->|HTTP| B1
    A1 -->|API| B3
    A2 -->|API| B3
```

**Статус:** 🟡 В процессе  
**Приоритет:** ВЫСОКИЙ

**Архитектура:**
- Джек: Android, OpenClaw, Termux
- Джон: Windows, n8n, localhost:5678
- Связь: Obsidian Shared + Git + Webhooks

**Блокер:**
- ⏳ n8n webhook 400 ошибка (настройка пути)

**Связи:**
- [[Tech-Cluster/n8n]] → Автоматизация
- [[../Shared/jack/2026-02-15-gpt-analysis-complete]] → Уведомление Джону

---

## 📚 PROJECT-004: Knowledge Base & RAG

```mermaid
graph LR
    subgraph SOURCES["📥 Источники:"]
        S1[36 GPT диалогов]
        S2[Obsidian vault]
        S3[Веб-страницы]
        S4[Книги/PDF]
    end
    
    subgraph PROCESSING["⚙️ Обработка:"]
        P1[Парсинг]
        P2[Чанкинг]
        P3[Embeddings]
    end
    
    subgraph STORAGE["💾 Хранение:"]
        ST1[Qdrant<br/>Векторная БД]
        ST2[PostgreSQL<br/>+ pgvector]
        ST3[ChromaDB<br/>Альтернатива]
    end
    
    subgraph USAGE["🔍 Использование:"]
        U1[Семантический поиск]
        U2[RAG для агентов]
        U3[Вопросы-ответы]
    end
    
    SOURCES --> PROCESSING
    P1 --> P2 --> P3
    PROCESSING --> STORAGE
    ST1 --> USAGE
    ST2 --> USAGE
    ST3 --> USAGE
```

**Статус:** ⏳ Заблокирован  
**Приоритет:** СРЕДНИЙ

**Зависимости:**
- PostgreSQL + pgvector
- Qdrant или ChromaDB
- n8n для пайплайнов

**Связи:**
- [[../../Projects/RAG-GPT-Integration/README]] → Полный план
- [[../GPT-Conversations/10-Mindmap-GPT-Analysis]] → Источник данных

---

## ⚙️ PROJECT-005: Домашняя автоматизация

```mermaid
graph TB
    subgraph HOME["🏠 Умный дом"]
        H1[Home Assistant]
        H2[Сенсоры]
        H3[Свет]
        H4[Климат]
        H5[Безопасность]
    end
    
    subgraph CONTROL["📱 Управление"]
        C1[POCO X6]
        C2[Asus T300LA<br/>Панель]
        C3[Telegram]
    end
    
    subgraph AUTOMATION["⚙️ Автоматизация"]
        A1[n8n flows]
        A2[MQTT]
        A3[Node-RED*]
    end
    
    HOME -->|управляет| CONTROL
    CONTROL -->|триггеры| AUTOMATION
    AUTOMATION -->|действия| HOME
```

**Статус:** 🟡 Планирование  
**Приоритет:** СРЕДНИЙ

**Оборудование:**
- Панель: Asus Transformer Book T300LA
- План: Home Assistant + n8n

**Связи:**
- [[People/Максим Яровой/Infrastructure-Evolution]] → Схема дачи
- [[Equipment/2024-12-28_676f9f07]] → Оборудование

---

## 📊 Сводная таблица проектов

| ID | Проект | Статус | Приоритет | Блокер | Ответственный |
|----|--------|--------|-----------|--------|---------------|
| P001 | Переезд на дачу | 🟡 | Высокий | Инфра неизвестна | Максим + Джек |
| P002 | VDS Self-Hosting | 🟡 | Высокий | Настройка | Джек + Джон |
| P003 | Multi-Agent | 🟡 | Высокий | Webhook 400 | Джон |
| P004 | RAG Knowledge | ⏳ | Средний | Базы данных | Джек + Джон |
| P005 | Умный дом | 🟡 | Средний | Оборудование | Джек |
| P006 | Mikrotik config | ⏳ | Средний | USB-C адаптер | Максим |

---

## 🔗 Связи проектов

```mermaid
graph TB
    P1[🏠 Дача инфра] --> P2[🌍 VDS стек]
    P2 --> P3[🤖 Multi-Agent]
    P2 --> P5[🏡 Умный дом]
    P3 --> P4[📚 RAG Knowledge]
    P5 --> P2
    P6[📶 Mikrotik] -.-> P1
    
    U[👤 Максим] --> P1
    U --> P6
    J1[🤖 Джек] --> P2
    J1 --> P3
    J1 --> P4
    J1 --> P5
    J2[🤖 Джон] --> P2
    J2 --> P3
    J2 --> P4
```

---

*Projects Dashboard | Статус на 2026-02-15*