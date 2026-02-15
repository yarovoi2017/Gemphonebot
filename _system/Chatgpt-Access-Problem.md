# Проблема: Доступ к Chatgpt файлам

## Статус
```
Папка: /storage/emulated/0/Documents/Chatgpt/
Статус: Существует
Доступ: Чтение структуры ✅
Содержимое: Недоступно ❌ (permissions)
```

## Причина
Android 11+ (Scoped Storage) ограничивает доступ Termux к:
- /storage/emulated/0/Documents/
- /storage/emulated/0/Download/
- Внешним папкам приложений

## Решения

### Вариант 1: Скопировать через Files app (рекомендуется)
```
1. Открыть Files (Google Files или системный)
2. Documents/Chatgpt/ → Выбрать все файлы
3. Копировать → termux/data/data/com.termux/files/home/vault/temp/Chatgpt/
4. Или поделиться в Termux
```

### Вариант 2: SAF (Storage Access Framework)
```
termux-saf -> выдать доступ к Documents
```

### Вариант 3: Настройки Android
```
Settings → Apps → Termux → Permissions → Files and media → Allow all files
```

### Вариант 4: ADB (если есть на ПК)
```
adb shell cp /sdcard/Documents/Chatgpt/* /data/data/com.termux/files/home/vault/
```

### Вариант 5: Syncthing
```
Настроить sync /storage/emulated/0/Documents/Chatgpt/ → ~/vault/Chatgpt-import/
```

## Что дальше
После копирования файлов в ~/vault/:
1. Проанализирую структуру
2. Извлеку полезную информацию  
3. Подготовлю для RAG/Qdrant/PostgreSQL
4. Интегрирую с n8n

## Срочность
⏳ Ожидает: копирование файлов Максимом

*Создано: 15 февраля 2026*
