#!/bin/bash

# Скрипт удаления фотобудки kiosk режима
# Восстанавливает обычный desktop режим

set -e

echo "🗑️ Удаление фотобудки kiosk режима..."

# Проверка прав root
if [[ $EUID -ne 0 ]]; then
   echo "❌ Этот скрипт должен запускаться с правами root (sudo)"
   exit 1
fi

# Остановить и отключить kiosk сервис
echo "🛑 Остановка kiosk сервиса..."
systemctl stop photobooth-kiosk 2>/dev/null || true
systemctl disable photobooth-kiosk 2>/dev/null || true

# Удалить файлы сервиса
echo "🗂️ Удаление файлов..."
rm -f /etc/systemd/system/photobooth-kiosk.service
rm -f /etc/sudoers.d/photobooth-kiosk

# Восстановить lightdm
echo "🖥️ Восстановление lightdm..."
systemctl enable lightdm
systemctl start lightdm

# Перезагрузить systemd
systemctl daemon-reload

echo "✅ Удаление завершено!"
echo ""
echo "🖥️ Desktop режим восстановлен"
echo "🔄 Для полного восстановления рекомендуется перезагрузка:"
echo "   sudo reboot"
