#!/bin/bash

echo "🚀 Запуск улучшенной фотобудки..."

# Переходим в директорию проекта
cd "$(dirname "$0")"

echo "📁 Текущая директория: $(pwd)"

# Проверяем наличие Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter не найден. Установите Flutter SDK."
    exit 1
fi

echo "📦 Установка зависимостей..."
flutter pub get

echo "🌐 Генерация локализации..."
flutter gen-l10n

echo "🔧 Очистка кэша (если нужно)..."
flutter clean
flutter pub get

echo "🌍 Запуск в веб-браузере..."
flutter run -d chrome --web-port=8080

echo "✅ Готово! Фотобудка должна открыться в браузере."
