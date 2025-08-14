# 🖥️ Kiosk Mode для Фотобудки

Kiosk режим позволяет запускать фотобудку как единственное приложение на экране без desktop окружения Linux.

## 🎯 Что такое Kiosk Mode?

- **Автозапуск** приложения при загрузке системы
- **Отсутствие** рабочего стола, панелей, меню Linux
- **Полноэкранный** режим только с интерфейсом фотобудки
- **Автоматический перезапуск** при сбоях
- **Скрытый курсор** мыши для чистого вида

## 📦 Установка Kiosk Mode

### 1. Обновите проект с GitHub:
```bash
cd ~/photobooth_dd
git pull origin main
```

### 2. Соберите приложение:
```bash
./build_linux.sh
```

### 3. Установите kiosk режим:
```bash
sudo ./install-kiosk.sh
```

### 4. Завершите текущий X сервер:
```bash
sudo systemctl stop lightdm
sudo pkill -f Xorg
```

### 5. Запустите kiosk режим:
```bash
sudo systemctl start photobooth-kiosk
```

## 📊 Управление Kiosk Mode

### Проверка статуса:
```bash
sudo systemctl status photobooth-kiosk
```

### Просмотр логов:
```bash
sudo journalctl -u photobooth-kiosk -f
```

### Остановка kiosk режима:
```bash
sudo systemctl stop photobooth-kiosk
```

### Перезапуск:
```bash
sudo systemctl restart photobooth-kiosk
```

## 🔧 Файлы Kiosk Mode

- **`start-kiosk.sh`** - скрипт запуска X сервера с приложением
- **`photobooth-kiosk.service`** - systemd сервис для автозапуска
- **`install-kiosk.sh`** - скрипт установки kiosk режима
- **`uninstall-kiosk.sh`** - скрипт удаления и восстановления desktop

## 🛡️ Безопасность

- Приложение запускается от пользователя `ddself`
- Минимальные права sudo только для остановки lightdm
- Автоматический перезапуск при сбоях
- Изоляция от системных процессов

## 🔄 Восстановление Desktop Mode

Для возврата к обычному desktop режиму:

```bash
sudo ./uninstall-kiosk.sh
sudo reboot
```

## ⚠️ Устранение неполадок

### Приложение не запускается:
```bash
# Проверьте логи
sudo journalctl -u photobooth-kiosk -n 50

# Проверьте права доступа
ls -la /opt/photobooth/
```

### Черный экран:
```bash
# Перезапустите сервис
sudo systemctl restart photobooth-kiosk

# Проверьте X сервер
ps aux | grep Xorg
```

### Возврат к desktop:
```bash
# Остановите kiosk
sudo systemctl stop photobooth-kiosk

# Запустите lightdm
sudo systemctl start lightdm
```

## 🎊 Готово!

После установки kiosk режима ваша фотобудка будет:
- ✅ Автоматически запускаться при загрузке
- ✅ Отображать только интерфейс фотобудки
- ✅ Перезапускаться при сбоях
- ✅ Работать без desktop окружения
