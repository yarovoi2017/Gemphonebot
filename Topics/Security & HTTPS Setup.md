# Security & HTTPS Setup Guide

## Текущая ситуация

### ✅ Уже безопасно:
- **ngrok**: HTTPS по умолчанию (TLS 1.3)
- **GitHub**: HTTPS + SSH опционально
- **Telegram**: MTProto encryption

### ⚠️ Нужно настроить:
- **n8n**: Сейчас HTTP, нужен HTTPS
- **MikroTik**: HTTPS для веб-интерфейса
- **Ubuntu сервисы**: SSL/TLS где нужно

## 1. HTTPS для n8n

### Вариант A: Через ngrok (уже работает)
```
https://unoxidated-ian-nonrepressibly.ngrok-free.dev
```
✅ TLS 1.3 автоматически

### Вариант B: Let's Encrypt (свой домен)
```bash
# Если есть домен
certbot --nginx -d n8n.yourdomain.com
```

### Вариант C: Self-signed (локально)
```bash
# Генерация сертификата
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/n8n.key \
  -out /etc/ssl/certs/n8n.crt
```

## 2. MikroTik HTTPS

```bash
# В OpenWRT на роутере
# Генерация сертификата
opkg install uhttpd-mod-tls
/etc/init.d/uhttpd restart

# Или через SSH
ssh root@192.168.1.1 "uci set uhttpd.main.redirect_https=1; uci commit"
```

## 3. Безопасность сети

### Firewall базовые правила:
```bash
# Ubuntu
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 5678/tcp  # n8n
ufw enable
```

### MikroTik firewall:
```bash
# Блокировать входящие кроме нужных
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -j DROP
```

## 4. API Keys & Secrets

### Где хранить:
```
~/.env                    # Локальные переменные
~/.vault/_system/         # В Obsidian (в .gitignore!)
Bitwarden/KeePass         # Для командных
```

### .env.example:
```bash
# n8n
N8N_API_KEY=eyJhbGciOiJIUzI1NiIs...
N8N_WEBHOOK_URL=https://....ngrok-free.dev

# GitHub
GITHUB_TOKEN=ghp_...

# Ngrok
NGROK_AUTHTOKEN=2_...

# Telegram
TELEGRAM_BOT_TOKEN=8316448597:...
```

## 5. HTTPS Проверка

```bash
# Проверить сертификат
curl -vI https://unoxidated-ian-nonrepressibly.ngrok-free.dev 2>&1 | grep -E "SSL|TLS|certificate"

# Проверить уязвимости
nmap --script ssl-enum-ciphers -p 443 hostname
```

## 6. Tailscale (Zero Trust)

Лучшее решение для безопасности:
```
Все устройства в Tailscale mesh VPN
→ Шифрование WireGuard
→ No открытые порты
→ Доступ только авторизованным
```

## Рекомендации

1. **Краткосрочно**: Использовать ngrok HTTPS (уже работает)
2. **Среднесрочно**: Настроить Tailscale для всех устройств
3. **Долгосрочно**: Свой домен + Let's Encrypt

## Что делаем сейчас?

- [ ] A: Настроить HTTPS для n8n напрямую
- [ ] B: Настроить Tailscale (Zero Trust VPN)
- [ ] C: Firewall rules для Ubuntu
- [ ] D: Всё сразу

**Выбирай!** 🔐
