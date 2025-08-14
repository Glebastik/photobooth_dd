#!/bin/bash

# Скрипт запуска фотобудки в kiosk режиме
# Запускает X сервер с приложением без desktop окружения

set -e

echo "🚀 Запуск фотобудки в kiosk режиме..."

# Остановить lightdm если запущен
sudo systemctl stop lightdm 2>/dev/null || true
sudo systemctl stop gdm 2>/dev/null || true

# Убить существующие X процессы
sudo pkill -f Xorg 2>/dev/null || true
sudo pkill -f lightdm 2>/dev/null || true

# Подождать немного
sleep 2

# Установить переменные окружения
export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Запустить X сервер с приложением
echo "🖥️ Запуск X сервера с фотобудкой..."
xinit /opt/photobooth/io_photobooth -- :0 -nolisten tcp vt7 -nocursor
