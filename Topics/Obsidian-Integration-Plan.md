# План Интеграции Obsidian Vault

## Текущая ситуация

### Два vault'а:

**1. Существующий (/storage/emulated/0/Documents/Obsidian/)**
```
Obsidian/
├── 1. Projects/
├── 2. Areas/
├── 3.Resources/
├── 4. Archive/
├── Gpt-conversations/
├── Templates/
└── .obsidian/ (настройки, плагины)
```

**2. Новый (~/vault/)**
```
vault/
├── People/
├── Topics/
├── Shared/
├── Daily/
├── Projects/
└── _system/
```

## Цель

Объединить данные из существующего vault'а и настроить git sync.

## Варианты интеграции

### Вариант A: Symlink (рекомендуется)
Создать symlink ~/vault → /storage/emulated/0/Documents/Obsidian/
```bash
# Backup существующего vault'
mv /storage/emulated/0/Documents/Obsidian /storage/emulated/0/Documents/Obsidian-backup

# Создать symlink
ln -s ~/vault /storage/emulated/0/Documents/Obsidian

# Теперь Obsidian app будет работать с ~/vault
```

### Вариант B: Копирование с синхронизацией
Скопировать данные из старого vault'а в новый
```bash
# Копировать структуру
rsync -av /storage/emulated/0/Documents/Obsidian/* ~/vault/ --exclude='.obsidian' --exclude='.smart-env'

# Настроить git
cd ~/vault && git init && git remote add origin ...
```

### Вариант C: Два vault'а с sync
Оставить оба, настроить автосинк между ними
```bash
# Скрипт синхронизации каждые 5 мин
# ~/vault ↔ /storage/emulated/0/Documents/Obsidian/
```

## Рекомендуемый план (Вариант B + структура PARA)

### Шаг 1: Анализ существующих данных
- [ ] Проверить Gpt-conversations (есть ли файлы)
- [ ] Проверить Projects, Areas, Resources, Archive
- [ ] Сохранить важные данные

### Шаг 2: Миграция с PARA
```
Старая структура → Новая
1. Projects/ → Projects/
2. Areas/ → Topics/ (или Areas/)
3. Resources/ → Topics/
4. Archive/ → _system/archive/
5. Gpt-conversations/ → People/GPT-conversations/
6. Templates/ → _system/templates/
```

### Шаг 3: Git интеграция
- [ ] git init в ~/vault
- [ ] .gitignore для .obsidian/
- [ ] Автосинк настроен

### Шаг 4: Тест
- [ ] Obsidian app открывает vault
- [ ] Git sync работает
- [ ] Данные доступны

## Скрипт миграции

```bash
#!/bin/bash
# migrate-obsidian.sh

OLD_VAULT="/storage/emulated/0/Documents/Obsidian"
NEW_VAULT="$HOME/vault"

# Backup
mv "$OLD_VAULT" "$OLD_VAULT-backup-$(date +%Y%m%d)"

# Создать структуру
mkdir -p "$NEW_VAULT/People/GPT-conversations"
mkdir -p "$NEW_VAULT/Areas"
mkdir -p "$NEW_VAULT/_system/archive"
mkdir -p "$NEW_VAULT/_system/templates"

# Копировать данные
rsync -av "$OLD_VAULT-backup/1. Projects/" "$NEW_VAULT/Projects/"
rsync -av "$OLD_VAULT-backup/2. Areas/" "$NEW_VAULT/Areas/"
rsync -av "$OLD_VAULT-backup/3.Resources/" "$NEW_VAULT/Topics/"
rsync -av "$OLD_VAULT-backup/4. Archive/" "$NEW_VAULT/_system/archive/"
rsync -av "$OLD_VAULT-backup/Gpt-conversations/" "$NEW_VAULT/People/GPT-conversations/"

# Дать разрешения
chmod -R 755 "$NEW_VAULT"

# Symlink для Obsidian app
ln -s "$NEW_VAULT" "$OLD_VAULT"

echo "✅ Миграция завершена!"
```

## Следующие шаги

1. **Решить вариант** (A, B или C)
2. **Backup** существующего vault'а
3. **Выполнить** миграцию
4. **Проверить** работу Obsidian app
5. **Настроить** git sync

## Примечания
- Важно сохранить `.obsidian/` (настройки)
- Git sync будет работать только для текстовых файлов
- Медиафайлы в Attachments/ (отдельно)
