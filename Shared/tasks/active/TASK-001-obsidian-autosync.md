---
id: TASK-001
title: Настройка автосинхронизации Obsidian
type: technical
priority: P0
status: in_progress
assignee: Джек (Jack)
created: 2026-02-15T03:00:00+03:00
deadline: 2026-02-15
---

# Задача: Автосинхронизация Obsidian

## Описание
Настроить автоматическую синхронизацию Obsidian vault с GitHub каждые 5 минут без участия пользователя.

## Текущий статус
- ✅ Git инициализирован
- ✅ Репозиторий на GitHub подключен
- ✅ Скрипт vault-autosync.sh создан
- ❌ Cron не работает в Termux
- ⏳ Нужна альтернатива для автозапуска

## Что нужно сделать

### Вариант 1: Termux:API (рекомендуется)
```bash
# Установить Termux:API из F-Droid
pkg install termux-api

# Настроить периодическую задачу
termux-job-scheduler --script ~/.openclaw/workspace/scripts/vault-autosync.sh --period-ms 300000
```

### Вариант 2: Infinite loop с фоновым процессом
```bash
# Создать фоновый процесс
while true; do
  ~/.openclaw/workspace/scripts/vault-autosync.sh
  sleep 300
done &
```

### Вариант 3: Tasker (если установлен)
- Создать задачу в Tasker на запуск скрипта каждые 5 мин

## Проверка
```bash
# Проверить статус последнего коммита
cd ~/vault && git log -1 --format="%h %s %cr"

# Проверить есть ли изменения для push
git status
```

## Результат
- [ ] Автопуш каждые 5 мин работает
- [ ] Джон видит изменения на GitHub
- [ ] Нет конфликтов при одновременной работе

## Заметки
- Токен GitHub сохранен в скрипте
- При конфликтах используется theirs strategy
- Логи сохраняются в ~/.openclaw/logs/

---
*Начато: 2026-02-15*
