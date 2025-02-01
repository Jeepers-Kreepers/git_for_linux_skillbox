#!/bin/bash

# Запуск контейнеров в фоновом режиме
docker compose up -d

# Проверка, что docker compose up успешно завершился
if [ $? -ne 0 ]; then
  echo "Ошибка при запуске docker compose up. Скрипт завершается."
  exit 1
fi

# Подключение к контейнеру в интерактивном режиме и запуск команды
docker compose exec angular_motor_speed bash -c 'python3 model_dc_motor.py'


# Проверка, что docker compose exec успешно завершился
if [ $? -ne 0 ]; then
  echo "Ошибка при выполнении команды в контейнере."
fi


echo "Работа скрипта завершена."