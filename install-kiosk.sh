#!/bin/bash

# Скрипт установки фотобудки в kiosk режиме
# Настраивает автозапуск приложения без desktop окружения

set -e

echo "🔧 Установка фотобудки в kiosk режиме..."

# Проверка прав root
if [[ $EUID -ne 0 ]]; then
   echo "❌ Этот скрипт должен запускаться с правами root (sudo)"
   exit 1
fi

# Остановить и отключить существующие сервисы
echo "🛑 Остановка существующих сервисов..."
systemctl stop photobooth 2>/dev/null || true
systemctl disable photobooth 2>/dev/null || true
systemctl stop lightdm 2>/dev/null || true
systemctl disable lightdm 2>/dev/null || true
systemctl stop gdm 2>/dev/null || true
systemctl disable gdm 2>/dev/null || true

# Создать директорию приложения если не существует
mkdir -p /opt/photobooth

# Скопировать файлы
echo "📁 Копирование файлов..."
cp -f photobooth-kiosk.service /etc/systemd/system/
cp -f start-kiosk.sh /opt/photobooth/
chmod +x /opt/photobooth/start-kiosk.sh

# Скопировать исполняемый файл если существует
if [ -f "build/linux/x64/release/bundle/io_photobooth" ]; then
    echo "📦 Копирование исполняемого файла..."
    cp -rf build/linux/x64/release/bundle/* /opt/photobooth/
    chmod +x /opt/photobooth/io_photobooth
fi

# Настроить права доступа
chown -R ddself:ddself /opt/photobooth

# Добавить пользователя в группы для доступа к устройствам
usermod -a -G video,audio,input,dialout ddself

# Настроить sudo для пользователя ddself (для остановки lightdm)
echo "ddself ALL=(ALL) NOPASSWD: /bin/systemctl stop lightdm, /bin/systemctl stop gdm, /usr/bin/pkill" > /etc/sudoers.d/photobooth-kiosk

# Перезагрузить systemd и включить сервис
echo "🔄 Настройка systemd..."
systemctl daemon-reload
systemctl enable photobooth-kiosk

echo "✅ Установка завершена!"
echo ""
echo "🚀 Для запуска kiosk режима выполните:"
echo "   sudo systemctl start photobooth-kiosk"
echo ""
echo "📊 Для проверки статуса:"
echo "   sudo systemctl status photobooth-kiosk"
echo "   sudo journalctl -u photobooth-kiosk -f"
echo ""
echo "🔄 Для автозапуска при загрузке системы сервис уже включен"
