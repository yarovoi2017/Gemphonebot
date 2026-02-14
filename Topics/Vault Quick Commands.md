# Быстрые команды для Vault

## Синхронизация
```bash
# Ручная синхронизация (commit + push)
~/.openclaw/workspace/scripts/vault-autosync.sh

# Или через alias (после перезапуска терминала)
vsync
```

## Проверка статуса
```bash
cd ~/vault && git status
# или
vstatus
```

## Ручной git workflow
```bash
cd ~/vault
git add .
git commit -m "сообщение"
git push
```

## Что синхронизируется
- People/ — профили
- Topics/ — документация  
- Shared/ — совместная работа с Джоном
- Daily/ — ежедневные заметки
- _system/ — системные данные

## GitHub
- URL: https://github.com/yarovoi2017/Gemphonebot
- Ветка: master
- Токен: сохранен в скрипте autosync

## Джон (Windows PC)
Может клонировать:
```bash
git clone https://github.com/yarovoi2017/Gemphonebot.git vault
```
