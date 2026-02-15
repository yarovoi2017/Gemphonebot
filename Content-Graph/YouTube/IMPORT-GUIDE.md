---
tags: [youtube, import, guide, setup, google-takeout]
---

# 📥 YouTube: Руководство по импорту

> Как получить свою историю просмотров из Google

---

## 🎯 Что можно получить

### Доступные данные:
- ✅ История просмотров (watch-history.html)
- ✅ Сохраненные плейлисты (playlists.json)
- ✅ Подписки на каналы (subscriptions.json)
- ✅ Комментарии (my-comments.html)
- ✅ Лайки (my-liked-videos.html)
- ⚠️ *Нельзя: сырые данные через API без OAuth*

---

## 📋 Шаг 1: Google Takeout

### Инструкция:

1. **Открыть**
   ```
   https://takeout.google.com
   ```

2. **Выбрать данные**
   - Нажать "Deselect all" (отменить всё)
   - Найти и отметить:
     - ☑️ **YouTube** → "All YouTube data included"

3. **Выбрать формат**
   - Формат: `.json` (для истории) + `.html` (для просмотра)
   - Архив: `.zip`

4. **Создать экспорт**
   - Нажать "Create export"
   - Ждать email (от 2 минут до нескольких часов)

5. **Скачать**
   - Ссылка придет на email
   - Скачать `takeout-2026-02-15.zip`

---

## 📦 Шаг 2: Распаковка

### Структура архива:
```
takeout-2026-02-15/
└── Takeout/
    └── YouTube/
        └── Ваши данные в YouTube/
            ├── 📁 history/
            │   ├── watch-history.html    ← ГЛАВНОЕ
            │   └── search-history.html
            ├── 📁 playlists/
            │   └── playlists.json      ← Плейлисты
            ├── 📁 subscriptions/
            │   └── subscriptions.json   ← Подписки
            └── 📁 my-comments/
                └── my-comments.html
```

---

## 🔧 Шаг 3: Копирование в vault

### Команды для Termux:

```bash
# Создать папку для импорта
mkdir -p ~/vault/Content-Graph/YouTube/takeout/

# Скопировать файлы (предполагается, что скачал в Downloads)
cp /storage/emulated/0/Download/takeout-*.zip ~/vault/Content-Graph/YouTube/

# Распаковать
cd ~/vault/Content-Graph/YouTube/
unzip takeout-*.zip

# Переименовать для удобства
mv takeout-*/Takeout/YouTube/Your*/*.html ./
mv takeout-*/Takeout/YouTube/Your*/*.json ./
```

---

## 🐍 Шаг 4: Парсинг через Python

### Скрипт для Obsidian:

```python
#!/data/data/com.termux/files/usr/bin/env python3
"""
YouTube Takeout Parser → Obsidian
Конвертирует watch-history.html в markdown
"""

import json
import re
from datetime import datetime
from pathlib import Path

def parse_watch_history(html_file):
    """Парсит watch-history.html"""
    with open(html_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    videos = []
    
    # Паттерн для записей
    # YouTube использует div с темами и ссылками
    pattern = r'<div[^>]*>.*?<a[^>]*href="([^"]*watch[^"]*)"[^>]*>(.*?)</a>.*?(<div[^>]*>(.*?)</div>)?.*?</div>'
    
    entries = re.findall(pattern, content, re.DOTALL)
    
    for entry in entries:
        url = entry[0]
        title = re.sub(r'<[^>]+>', '', entry[1])  # Убрать HTML
        
        videos.append({
            'title': title.strip(),
            'url': url,
            'watched_at': parse_date(entry[3]) if len(entry) > 3 else None
        })
    
    return videos

def create_markdown(videos, output_file):
    """Создает Obsidian markdown"""
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("---\n")
        f.write("tags: [youtube, import, auto-generated]\n")
        f.write("date: {}\n".format(datetime.now().strftime('%Y-%m-%d')))
        f.write("---\n\n")
        f.write("# 🎬 YouTube История просмотров\n\n")
        f.write("> Импортировано из Google Takeout\n\n")
        f.write("## 📊 Статистика\n\n")
        f.write(f"- **Всего видео:** {len(videos)}\n")
        f.write("- **Период:** ...\n\n")
        
        f.write("## 📹 Видео\n\n")
        
        for i, video in enumerate(videos[:100]):  # Первые 100
            f.write(f"### {i+1}. {video['title']}\n")
            f.write(f"- **URL:** {video['url']}\n")
            if video['watched_at']:
                f.write(f"- **Дата:** {video['watched_at']}\n")
            f.write(f"- **Теги:** #youtube #import\n")
            f.write("\n")

if __name__ == '__main__':
    import sys
    html_file = sys.argv[1] if len(sys.argv) > 1 else 'watch-history.html'
    output = sys.argv[2] if len(sys.argv) > 2 else 'imported-history.md'
    
    videos = parse_watch_history(html_file)
    create_markdown(videos, output)
    print(f"✅ Обработано: {len(videos)} видео")
    print(f"📝 Сохранено: {output}")
```

---

## 📊 Шаг 5: Анализ паттернов

### Что искать в данных:

```yaml
Паттерны_просмотра:
  Время_дня:
    утро: [6:00-9:00] → тип контента?
    рабочее: [9:00-18:00] → обучение?
    вечер: [18:00-23:00] → развлечение?
    ночь: [23:00-6:00] → редко?
  
  Дни_недели:
    будни: vs выходные
    разница?
  
  Клубки_просмотра:
    5+ видео подряд: тема?
    single-view: случайно?
  
  Каналы:
    top-10: кого чаще?
    новые: когда открываешь?
  
  Темы:
    tech: доля?
    education: доля?
    entertainment: доля?
```

---

## 🛠️ Автоматизация (для Джека)

### Скрипт для агента:
```python
def analyze_youtube_data(takeout_folder):
    """
    Джек анализирует данные и создает профиль Максима
    """
    
    # Загрузить
    videos = load_watch_history(f"{takeout_folder}/watch-history.html")
    playlists = load_playlists(f"{takeout_folder}/playlists.json")
    subs = load_subscriptions(f"{takeout_folder}/subscriptions.json")
    
    # Анализировать
    insights = {
        'top_channels': get_top_channels(videos, 20),
        'watch_times': analyze_time_patterns(videos),
        'content_themes': categorize_content(videos),
        'learning_videos': filter_by_keywords(videos, ['tutorial', 'how to', 'learn']),
        'binge_sessions': find_binge_patterns(videos),
        'discovery_rate': calculate_new_channels_per_month(videos)
    }
    
    # Обновить Knowledge Graph
    update_personal_insights(insights)
    update_content_recommendations(insights)
    
    return insights
```

---

## 📂 Куда складывать

```
vault/Content-Graph/YouTube/
├── IMPORT-GUIDE.md (это файл)
├── takeout/                    ← Сюда распаковывать
│   ├── watch-history.html
│   ├── playlists.json
│   └── subscriptions.json
├── imported/
│   ├── 2026-02-15-watched.md   ← Спарсенные
│   ├── 2026-02-15-playlists.md
│   └── 2026-02-15-analysis.md    ← Инсайты
└── patterns/
    ├── watch-time-map.md        ← Время дня
    ├── channel-preferences.md   ← Предпочтения
    └── learning-topics.md       ← Обучение
```

---

## ✅ Чеклист импорта

- [ ] Запросить Takeout на takeout.google.com
- [ ] Дождаться email (может занять часы)
- [ ] Скачать zip
- [ ] Перенести в vault/Content-Graph/YouTube/
- [ ] Распаковать
- [ ] Запустить скрипт парсинга
- [ ] Проверить результаты
- [ ] Джек проанализирует паттерны
- [ ] Обновить Content Graph

---

## 🔗 Связи

- [[00-Content-Overview]] ← Общая архитектура
- [[Mood-Context]] ← Связь музыки и активности
- [[../Knowledge-Graph/Personal-Cluster]] ← Интеграция с личным

---

*Import Guide | Google Takeout → Obsidian*