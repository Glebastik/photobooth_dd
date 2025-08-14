# 📸 Улучшенная Фотобудка I/O

[![Photo Booth Header][logo]][photo_booth_link]

[![io_photobooth][build_status_badge]][workflow_link]
![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Фотобудка, созданная с использованием [Flutter][flutter_link] и [Firebase][firebase_link], расширенная для профессионального использования с поддержкой Linux и киоск-режима.

**🚀 Новые возможности:**
- 🇷🇺 **Русская локализация** - полный перевод интерфейса
- 📷 **Поддержка внешних камер** - USB/веб-камеры с настройками качества
- 🖨️ **Интеграция с принтером** - печать фотографий через CUPS
- 🖥️ **Киоск-режим** - полноэкранный режим для терминалов
- 🐧 **Linux развертывание** - автоматические скрипты установки
- ⚙️ **Systemd сервис** - автозапуск при загрузке системы
- 🔧 **Конфигурация** - настраиваемые параметры через файл конфигурации

*Основано на оригинальном проекте [Very Good Ventures][very_good_ventures_link] в партнерстве с Google*

*Расширено для коммерческого использования 🤖*

---

## 🚀 Быстрый старт

### Веб-версия
Для запуска веб-версии используйте:

```sh
$ flutter run -d chrome
```

### Linux Desktop
Для сборки и развертывания на Linux:

```sh
# Сборка проекта
$ ./build_linux.sh

# Установка как системный сервис
$ sudo ./install_linux.sh
```

_📋 Подробные инструкции по развертыванию на Linux см. в [LINUX_DEPLOYMENT.md](LINUX_DEPLOYMENT.md)_

---

## 🧪 Запуск тестов

Для запуска всех unit и widget тестов используйте:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

Для просмотра отчета о покрытии кода используйте [lcov](https://github.com/linux-test-project/lcov):

```sh
# Генерация отчета о покрытии
$ genhtml coverage/lcov.info -o coverage/
# Открытие отчета
$ open coverage/index.html
```

---

## 🌐 Работа с переводами

Проект использует [flutter_localizations][flutter_localizations_link] и следует [официальному руководству по интернационализации Flutter][internationalization_link].

### Добавление строк

1. Для добавления новой локализуемой строки откройте файл `app_ru.arb` в `lib/l10n/arb/app_ru.arb`:

```arb
{
    "@@locale": "ru",
    "counterAppBarTitle": "Счетчик",
    "@counterAppBarTitle": {
        "description": "Текст, отображаемый в AppBar страницы счетчика"
    }
}
```

2. Добавьте новый ключ/значение и описание:

```arb
{
    "@@locale": "ru",
    "counterAppBarTitle": "Счетчик",
    "@counterAppBarTitle": {
        "description": "Текст, отображаемый в AppBar страницы счетчика"
    },
    "helloWorld": "Привет, мир!",
    "@helloWorld": {
        "description": "Текст приветствия"
    }
}
```

3. Используйте новую строку:

```dart
import 'package:io_photobooth/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Добавление переводов

1. Для каждой поддерживаемой локали добавьте новый ARB файл в `lib/l10n/arb/`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   ├── app_ru.arb
│   │   └── app_es.arb
```

2. Добавьте переведенные строки в каждый `.arb` файл:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_ru.arb`

```arb
{
    "@@locale": "ru",
    "counterAppBarTitle": "Счетчик",
    "@counterAppBarTitle": {
        "description": "Текст, отображаемый в AppBar страницы счетчика"
    }
}
```

---

## 🏗️ Архитектура проекта

### Основные компоненты

- **`EnhancedPhotobooth`** - улучшенный виджет фотобудки с киоск-режимом
- **`CameraService`** - сервис управления камерами (USB/веб-камеры)
- **`PrinterService`** - сервис печати через CUPS
- **`LanguageSelector`** - переключатель языков
- **`LocalizedApp`** - локализованное приложение

### Поддерживаемые платформы

- ✅ **Web** - браузерная версия
- ✅ **Linux Desktop** - нативное приложение с systemd
- ✅ **Windows Desktop** - нативное приложение
- ✅ **macOS Desktop** - нативное приложение

---

## 🔧 Конфигурация

Настройки приложения находятся в файле `photobooth.conf`:

```ini
[display]
fullscreen=true
width=1920
height=1080

[camera]
default_camera_index=0
photo_width=1920
photo_height=1080

[kiosk]
enable_kiosk_mode=true
auto_start_delay=5
idle_timeout=300
```

---

## 📋 Системные требования

### Linux
- Ubuntu 20.04+ / Debian 11+ / Fedora 35+
- 2GB RAM (рекомендуется 4GB+)
- USB камера или встроенная камера
- Принтер, совместимый с CUPS (опционально)

### Зависимости
```bash
# Ubuntu/Debian
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa

# Fedora
sudo dnf install -y curl git unzip xz zip mesa-libGLU
```

---

## 🚀 Развертывание

### Автоматическая установка на Linux
```bash
git clone https://github.com/Glebastik/photobooth_dd.git
cd photobooth_dd
./build_linux.sh
sudo ./install_linux.sh
```

### Управление сервисом
```bash
sudo systemctl status photobooth    # статус
sudo systemctl restart photobooth   # перезапуск
sudo journalctl -u photobooth -f    # логи
```

---

## 📞 Поддержка

- 📖 **Документация**: [LINUX_DEPLOYMENT.md](LINUX_DEPLOYMENT.md)
- 🐛 **Баги**: [GitHub Issues](https://github.com/Glebastik/photobooth_dd/issues)
- 💬 **Обсуждения**: [GitHub Discussions](https://github.com/Glebastik/photobooth_dd/discussions)

[build_status_badge]: https://github.com/flutter/photobooth/actions/workflows/main.yaml/badge.svg
[coverage_badge]: coverage_badge.svg
[firebase_link]: https://firebase.google.com/
[flutter_link]: https://flutter.dev
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[google_io_link]: https://events.google.com/io/
[blog_link]: https://medium.com/flutter/how-its-made-i-o-photo-booth-3b8355d35883
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo]: art/header.png
[photo_booth_link]: https://photobooth.flutter.dev
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[very_good_ventures_link]: https://verygood.ventures/
[workflow_link]: https://github.com/flutter/photobooth/actions/workflows/main.yaml
