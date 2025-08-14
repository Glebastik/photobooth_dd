#!/bin/bash

# Скрипт запуска фотобудки в kiosk режиме
# Останавливает desktop managers и запускает X сервер с приложением

# Функция логирования
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [KIOSK] $1" | tee -a /home/ddself/logs/photobooth-kiosk.log
}

# Функция очистки при выходе
cleanup() {
    log "🧹 Очистка процессов..."
    pkill -f "io_photobooth" 2>/dev/null || true
    pkill -f "Xorg :0" 2>/dev/null || true
    pkill -f "unclutter" 2>/dev/null || true
}

# Установить обработчик сигналов
trap cleanup EXIT TERM INT

log "🚀 Запуск фотобудки в kiosk режиме..."

# Остановить display managers
log "🛑 Остановка display managers..."
sudo systemctl stop lightdm 2>/dev/null || true
sudo systemctl stop gdm 2>/dev/null || true
sudo pkill -f Xorg 2>/dev/null || true

# Подождать завершения процессов
log "⏳ Ожидание завершения процессов..."
sleep 3

# Проверить, что приложение существует
if [ ! -f "/opt/photobooth/build/linux/x64/release/bundle/io_photobooth" ]; then
    log "❌ Приложение не найдено: /opt/photobooth/build/linux/x64/release/bundle/io_photobooth"
    exit 1
fi

# Настроить переменные окружения
export DISPLAY=:0
export XAUTHORITY=/home/ddself/.Xauthority

# Создать .Xauthority если не существует
if [ ! -f "/home/ddself/.Xauthority" ]; then
    log "🔑 Создание .Xauthority..."
    touch /home/ddself/.Xauthority
    chown ddself:ddself /home/ddself/.Xauthority
fi

# Запустить X сервер в фоне
log "🖥️ Запуск X сервера..."
Xorg :0 -seat seat0 -auth /home/ddself/.Xauthority vt1 &
X_PID=$!

# Подождать запуска X сервера
log "⏳ Ожидание запуска X сервера..."
sleep 5

# Проверить, что X сервер запустился
if ! ps -p $X_PID > /dev/null; then
    log "❌ X сервер не запустился"
    exit 1
fi

# Скрыть курсор мыши
log "🖱️ Скрытие курсора..."
unclutter -display :0 -noevents -grab &

# Запустить приложение фотобудки
log "📸 Запуск приложения фотобудки..."
cd /opt/photobooth

# Запуск приложения с перенаправлением вывода
./build/linux/x64/release/bundle/io_photobooth 2>&1 | tee -a /home/ddself/logs/photobooth-app.log &
APP_PID=$!

log "✅ Приложение запущено (PID: $APP_PID, X PID: $X_PID)"

# Ожидать завершения приложения
wait $APP_PID

log "🏁 Приложение завершено"
