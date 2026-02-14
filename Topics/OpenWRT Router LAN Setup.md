# OpenWRT Router Setup via LAN (POCO X6 Pro)

## Схема подключения

```
[POCO X6 Pro] ←→ [USB-C to Ethernet] ←→ [LAN порт OpenWRT]
     ↓
  Termux (OpenClaw)
     ↓
  SSH/Telnet/OpenWRT
```

## Что понадобится

1. **USB-C to Ethernet адаптер** для POCO X6 Pro
2. **Ethernet кабель** (RJ45)
3. **OpenWRT роутер** с заводскими настройками или доступом

## Подготовка телефона

### 1. Проверка USB-C Ethernet

```bash
# Подключи адаптер и проверь
lsusb
# Должно показать Ethernet device

# Проверить сетевой интерфейс
ip link show
# Должен появиться новый интерфейс (eth0, usb0 или похожий)
```

### 2. Настройка сети

```bash
# Назначить статический IP для связи с роутером
# OpenWRT по умолчанию: 192.168.1.1

su -c "ifconfig eth0 192.168.1.2 netmask 255.255.255.0 up"

# Проверить ping
ping 192.168.1.1
```

## Подключение к роутеру

### Вариант 1: SSH (рекомендуется)

```bash
# Стандартный OpenWRT
default_ip=192.168.1.1
default_user=root
# Пароль пустой или какой-то (зависит от прошивки)

ssh root@192.168.1.1

# Если первое подключение:
ssh -o StrictHostKeyChecking=no root@192.168.1.1
```

### Вариант 2: Telnet (если SSH не настроен)

```bash
# Установить telnet в Termux
pkg install inetutils

# Подключиться
telnet 192.168.1.1

# В OpenWRT:
# - Установить пароль: passwd
# - Включить SSH: /etc/init.d/dropbear enable
```

### Вариант 3: Web интерфейс (LuCI)

```bash
# Открыть браузер
# http://192.168.1.1

# Или через Termux:
termux-open-url http://192.168.1.1
```

## Скрипт автоматизации

```bash
#!/data/data/com.termux/files/usr/bin/bash

# OpenWRT Router Connector
# Для POCO X6 Pro + USB Ethernet

ROUTER_IP="${ROUTER_IP:-192.168.1.1}"
ROUTER_USER="${ROUTER_USER:-root}"
PHONE_IP="192.168.1.2"

# Найти Ethernet интерфейс
find_eth_interface() {
    # Ищем интерфейс, который не lo, wlan, rmnet
    ip link show | grep -E "^[0-9]+: (eth|usb|enx)" | awk -F: '{print $2}' | tr -d ' ' | head -1
}

# Настроить сеть
setup_network() {
    local eth_iface=$(find_eth_interface)
    
    if [ -z "$eth_iface" ]; then
        echo "❌ Ethernet интерфейс не найден"
        echo "Подключи USB-C to Ethernet адаптер"
        return 1
    fi
    
    echo "✅ Найден интерфейс: $eth_iface"
    
    # Настроить IP
    echo "🌐 Настройка IP $PHONE_IP..."
    su -c "ifconfig $eth_iface $PHONE_IP netmask 255.255.255.0 up"
    
    # Проверить
    echo "📡 Проверка связи с роутером..."
    if ping -c 1 -W 3 $ROUTER_IP > /dev/null 2>&1; then
        echo "✅ Роутер доступен по $ROUTER_IP"
        return 0
    else
        echo "❌ Роутер не отвечает"
        echo "Проверь подключение кабеля"
        return 1
    fi
}

# SSH подключение
connect_ssh() {
    echo "🔌 Подключение к $ROUTER_USER@$ROUTER_IP..."
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$ROUTER_USER@$ROUTER_IP"
}

# Telnet подключение
connect_telnet() {
    echo "🔌 Telnet к $ROUTER_IP..."
    telnet $ROUTER_IP
}

# Web интерфейс
open_web() {
    echo "🌐 Открываю web интерфейс..."
    termux-open-url "http://$ROUTER_IP"
}

# Сканирование сети
scan_network() {
    echo "🔍 Сканирование сети 192.168.1.0/24..."
    for ip in 192.168.1.{1..254}; do
        ping -c 1 -W 1 $ip > /dev/null 2>&1 && echo "🟢 $ip доступен" &
    done
    wait
}

# Главное меню
case "$1" in
    setup)
        setup_network
        ;;
    ssh)
        setup_network && connect_ssh
        ;;
    telnet)
        setup_network && connect_telnet
        ;;
    web)
        setup_network && open_web
        ;;
    scan)
        setup_network && scan_network
        ;;
    status)
        echo "Ethernet интерфейс: $(find_eth_interface)"
        echo "Router IP: $ROUTER_IP"
        ip addr show $(find_eth_interface) 2>/dev/null || echo "Не подключен"
        ;;
    *)
        echo "OpenWRT Router Connector"
        echo ""
        echo "Использование: router-connect {command}"
        echo ""
        echo "Команды:"
        echo "  setup    Настроить сеть"
        echo "  ssh      Подключиться по SSH"
        echo "  telnet   Подключиться по Telnet"
        echo "  web      Открыть web интерфейс"
        echo "  scan     Сканировать сеть"
        echo "  status   Показать статус"
        echo ""
        echo "Требования:"
        echo "  1. USB-C to Ethernet адаптер"
        echo "  2. Ethernet кабель"
        echo "  3. Root доступ (su)"
        ;;
esac
```

## Пошаговая настройка

### Шаг 1: Подключение

1. Подключи USB-C to Ethernet адаптер к POCO X6 Pro
2. Подключи Ethernet кабель: адаптер ↔ роутер (LAN порт)
3. Убедись что роутер включён

### Шаг 2: Настройка сети

```bash
# Дать root права Termux
pkg install tsu

# Запустить с root
tsu

# Настроить сеть
~/.openclaw/workspace/scripts/router-connect.sh setup
```

### Шаг 3: Подключение

```bash
# SSH (лучший вариант)
~/.openclaw/workspace/scripts/router-connect.sh ssh

# Или web интерфейс
~/.openclaw/workspace/scripts/router-connect.sh web
```

## Настройка OpenWRT

### 1. Базовая настройка

```bash
# В OpenWRT (после подключения)

# Установить пароль root
passwd

# Включить SSH
/etc/init.d/dropbear enable
/etc/init.d/dropbear start

# Настроить WAN (если нужно)
uci set network.wan=interface
uci set network.wan.proto='dhcp'
uci commit network
/etc/init.d/network reload
```

### 2. Настройка WiFi клиента

```bash
# Сканировать сети
iwinfo wlan0 scan

# Настроить подключение к телефону
uci set wireless.@wifi-device[0].disabled='0'
uci set wireless.@wifi-iface[0].mode='sta'
uci set wireless.@wifi-iface[0].ssid='PocoX6Pro_Hotspot'
uci set wireless.@wifi-iface[0].key='your_wifi_password'
uci set wireless.@wifi-iface[0].encryption='psk2'
uci commit wireless
wifi reload
```

### 3. VPN на Timeweb

```bash
# Установить WireGuard
opkg update
opkg install wireguard-tools

# Настроить (см. TIMEWEB-SETUP.md)
```

## Проверка

```bash
# Проверить подключение роутера к интернету
ping 8.8.8.8

# Проверить VPN
wg show

# Проверить маршрутизацию
traceroute 8.8.8.8
```

## Troubleshooting

### Нет Ethernet интерфейса

```bash
# Проверить USB устройства
lsusb

# Перезагрузить адаптер
# Отключить и подключить заново

# Проверить драйвер
lsmod | grep -E "usbnet|r8152|ax88179"
```

### Нет связи с роутером

```bash
# Проверить IP
ip addr show

# Проверить кабель
# Попробовать другой порт LAN
# Сбросить роутер к заводским
```

### SSH не работает

```bash
# Попробовать Telnet
~/.openclaw/workspace/scripts/router-connect.sh telnet

# Или через web
~/.openclaw/workspace/scripts/router-connect.sh web
```

## Автоматизация через OpenClaw

Когда роутер будет настроен, я смогу:

```bash
# Управлять через SSH
ssh root@192.168.1.1 "uci show network"

# Мониторить
ssh root@192.168.1.1 "cat /proc/net/dev"

# Настраивать
ssh root@192.168.1.1 "uci set ... && uci commit"
```

## Безопасность

1. **Смени пароль root** сразу после первого входа
2. **Отключи Telnet** после настройки SSH
3. **Включи firewall** правила
4. **Обнови OpenWRT** до последней версии

## Что дальше

После подключения:
1. Базовая настройка OpenWRT
2. WiFi клиент → твой телефон
3. VPN на Timeweb
4. Автоматизация через меня (Джек)

**Готов подключать роутер?** Подключи адаптер и кабель, потом скажи — помогу настроить сеть! 🔧
