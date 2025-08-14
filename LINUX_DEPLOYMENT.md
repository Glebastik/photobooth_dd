# 🐧 Photobooth Linux Deployment Guide

Это руководство поможет вам развернуть Flutter-приложение фотобудки на Linux с автозапуском через systemd.

## 📋 Требования

### Системные требования
- **ОС**: Ubuntu 20.04+ / Debian 11+ / Fedora 35+ / другие современные дистрибутивы Linux
- **Архитектура**: x86_64
- **Память**: минимум 2GB RAM, рекомендуется 4GB+
- **Место на диске**: минимум 1GB свободного места
- **Графическая система**: X11 или Wayland
- **Камера**: USB веб-камера или встроенная камера
- **Принтер**: (опционально) совместимый с CUPS принтер

### Программные зависимости
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa

# Fedora
sudo dnf install -y curl git unzip xz zip mesa-libGLU

# Arch Linux
sudo pacman -S curl git unzip xz zip glu
```

## 🚀 Установка Flutter (если не установлен)

1. **Скачайте Flutter SDK**:
```bash
cd ~/
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz
tar xf flutter_linux_3.24.3-stable.tar.xz
```

2. **Добавьте Flutter в PATH**:
```bash
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

3. **Проверьте установку**:
```bash
flutter doctor
```

## 🔨 Сборка проекта

1. **Перейдите в директорию проекта**:
```bash
cd /path/to/photobooth
```

2. **Сделайте скрипт сборки исполняемым**:
```bash
chmod +x build_linux.sh
```

3. **Запустите сборку**:
```bash
./build_linux.sh
```

Скрипт автоматически:
- Проверит установку Flutter
- Включит поддержку Linux desktop
- Очистит предыдущие сборки
- Установит зависимости
- Соберет приложение в release режиме
- Создаст пакет для развертывания в папке `deploy/photobooth/`

## ⚙️ Установка как системный сервис

1. **Сделайте скрипт установки исполняемым**:
```bash
chmod +x install_linux.sh
```

2. **Запустите установку с правами администратора**:
```bash
sudo ./install_linux.sh
```

Скрипт автоматически:
- Создаст пользователя `photobooth`
- Скопирует файлы приложения в `/opt/photobooth/`
- Установит systemd сервис
- Запустит сервис с автозапуском

## 🎛️ Управление сервисом

### Основные команды
```bash
# Проверить статус
sudo systemctl status photobooth

# Запустить сервис
sudo systemctl start photobooth

# Остановить сервис
sudo systemctl stop photobooth

# Перезапустить сервис
sudo systemctl restart photobooth

# Включить автозапуск
sudo systemctl enable photobooth

# Отключить автозапуск
sudo systemctl disable photobooth
```

### Просмотр логов
```bash
# Просмотр логов в реальном времени
sudo journalctl -u photobooth -f

# Просмотр последних логов
sudo journalctl -u photobooth -n 50

# Просмотр логов за сегодня
sudo journalctl -u photobooth --since today
```

## 🖥️ Настройка дисплея

### Для киоска (полноэкранный режим)
1. **Отключите заставку и спящий режим**:
```bash
# Для X11
xset s off
xset -dpms
xset s noblank

# Добавьте в ~/.xprofile для постоянного эффекта
echo "xset s off" >> ~/.xprofile
echo "xset -dpms" >> ~/.xprofile
echo "xset s noblank" >> ~/.xprofile
```

2. **Настройте автологин** (Ubuntu):
```bash
sudo systemctl edit getty@tty1.service
```
Добавьте:
```ini
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin photobooth %I $TERM
```

### Для Wayland
Убедитесь, что переменная `WAYLAND_DISPLAY` правильно установлена в сервисе.

## 📷 Настройка камеры

1. **Проверьте доступные камеры**:
```bash
ls /dev/video*
```

2. **Установите права доступа**:
```bash
sudo usermod -a -G video photobooth
```

3. **Проверьте камеру**:
```bash
# Установите v4l-utils для тестирования
sudo apt install v4l-utils  # Ubuntu/Debian
sudo dnf install v4l-utils  # Fedora

# Проверьте камеру
v4l2-ctl --list-devices
```

## 🖨️ Настройка принтера

1. **Установите CUPS**:
```bash
# Ubuntu/Debian
sudo apt install cups

# Fedora
sudo dnf install cups

# Запустите CUPS
sudo systemctl enable cups
sudo systemctl start cups
```

2. **Добавьте пользователя в группу печати**:
```bash
sudo usermod -a -G lpadmin photobooth
```

3. **Настройте принтер через веб-интерфейс**:
Откройте http://localhost:631 и добавьте принтер.

## 🔧 Устранение неполадок

### Приложение не запускается
1. Проверьте логи: `sudo journalctl -u photobooth -n 50`
2. Проверьте права доступа: `ls -la /opt/photobooth/`
3. Проверьте зависимости: `ldd /opt/photobooth/io_photobooth`

### Проблемы с дисплеем
1. Проверьте переменную DISPLAY: `echo $DISPLAY`
2. Для Wayland проверьте: `echo $WAYLAND_DISPLAY`
3. Убедитесь, что X11 forwarding включен

### Камера не работает
1. Проверьте устройства: `ls -la /dev/video*`
2. Проверьте права: `groups photobooth`
3. Проверьте, не используется ли камера другим процессом

### Принтер не работает
1. Проверьте статус CUPS: `systemctl status cups`
2. Проверьте принтеры: `lpstat -p`
3. Проверьте очередь печати: `lpq`

## 🗑️ Удаление

Для удаления приложения:
```bash
chmod +x uninstall_linux.sh
sudo ./uninstall_linux.sh
```

## 📁 Структура файлов

```
/opt/photobooth/           # Основная директория приложения
├── io_photobooth          # Исполняемый файл
├── lib/                   # Библиотеки Flutter
├── data/                  # Данные приложения
└── assets/                # Ресурсы приложения

/etc/systemd/system/       # Системные сервисы
└── photobooth.service     # Сервис фотобудки
```

## 🔐 Безопасность

Сервис настроен с ограничениями безопасности:
- Запуск от непривилегированного пользователя
- Ограниченный доступ к файловой системе
- Изолированная временная директория
- Запрет на получение новых привилегий

## 📞 Поддержка

При возникновении проблем:
1. Проверьте логи сервиса
2. Убедитесь в соблюдении системных требований
3. Проверьте права доступа к устройствам
4. Обратитесь к разделу "Устранение неполадок"
