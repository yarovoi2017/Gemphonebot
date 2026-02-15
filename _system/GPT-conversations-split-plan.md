# План разделения GPT-conversations

## Цель
Разделить существующие GPT-диалоги на две категории:
1. **Активные/Текущие** — для работы
2. **Архив** — для истории

## Варианты разделения

### Вариант A: По дате
```
Gpt-conversations/
├── Current/          # Последние 30/60/90 дней
│   ├── 2026-02/
│   ├── 2026-01/
│   └── ...
└── Archive/          # Остальное
    ├── 2025/
    ├── 2024/
    └── Older/
```

### Вариант B: По тематике
```
Gpt-conversations/
├── Tech/             # IT, программирование, DevOps
│   ├── OpenClaw/
│   ├── n8n/
│   └── Linux/
├── Personal/         # Личное
│   └── ...
├── Projects/         # Проекты
│   └── ...
└── Archive/          # Мусор/неактуальное
```

### Вариант C: По важности (PARA метод)
```
Gpt-conversations/
├── 1. Projects/      # Активные проекты
│   ├── Project-A/
│   └── Project-B/
├── 2. Areas/         # Постоянные темы
│   ├── IT-Skills/
│   ├── Home-Automation/
│   └── Learning/
├── 3. Resources/     # Справочная информация
│   ├── Code-snippets/
│   ├── Tutorials/
│   └── Solutions/
└── 4. Archive/       # Завершенное/неактуальное
    ├── 2025/
    └── 2024/
```

## Рекомендация: Вариант C (PARA)

Самая структурированная система.

## Скрипт разделения

```bash
#!/bin/bash
# split-gpt-conversations.sh

SOURCE="/storage/emulated/0/Documents/Obsidian/Gpt-conversations"
TARGET_CURRENT="$HOME/vault/People/Максим Яровой/GPT-conversations/Current"
TARGET_ARCHIVE="$HOME/vault/People/Максим Яровой/GPT-conversations/Archive"

mkdir -p "$TARGET_CURRENT" "$TARGET_ARCHIVE"

# Сканировать файлы
for file in "$SOURCE"/*.md; do
    if [ -f "$file" ]; then
        # Получить дату из имени или содержимого
        date_str=$(echo "$file" | grep -oE '[0-9]{4}-[0-9]{2}' | head -1)
        
        if [ -n "$date_str" ]; then
            year=$(echo "$date_str" | cut -d'-' -f1)
            month=$(echo "$date_str" | cut -d'-' -f2)
            
            # Определить: текущий или архив
            if [ "$year" = "2026" ] || ([ "$year" = "2025" ] && [ "$month" -gt "10" ]); then
                # Текущее
                mkdir -p "$TARGET_CURRENT/$year-$month"
                cp "$file" "$TARGET_CURRENT/$year-$month/"
            else
                # Архив
                mkdir -p "$TARGET_ARCHIVE/$year"
                cp "$file" "$TARGET_ARCHIVE/$year/"
            fi
        fi
    fi
done

echo "✅ Разделение завершено!"
echo "Текущее: $TARGET_CURRENT"
echo "Архив: $TARGET_ARCHIVE"
```

## Ручное разделение (если скрипт не работает)

### Шаг 1: Создать структуру
```bash
mkdir -p ~/vault/People/Максим\ Яровой/GPT-conversations/{Current,Archive}
```

### Шаг 2: Вручную скопировать файлы
- **Актуальное** → Current/
- **Старое** → Archive/

### Шаг 3: Git sync
```bash
cd ~/vault
git add .
git commit -m "[maxim] Split GPT conversations"
git push
```

## Итоговая структура

```
vault/
└── People/
    └── Максим Яровой/
        ├── Profile.md
        └── GPT-conversations/
            ├── Current/         # Рабочие диалоги
            │   └── (недавние)
            └── Archive/         # История
                └── (старые)
```

## Что нужно от Максима

Уточнить критерий разделения:
- По дате? (старое/новое)
- По тематике? (IT/личное/проекты)
- По важности? (нужное/ненужное)

**Какой вариант?** A, B или C?
