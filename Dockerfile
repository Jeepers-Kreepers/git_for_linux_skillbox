# dokerfile
# Устанавливаем базовый образ Python 3.10.16
FROM python:3.10.16

# Set environment variables
# чтобы Python не создавал файлы .pyc
ENV PYTHONDONTWRITEBYTECODE 1
# устанавливает вывод без буферизации
ENV PYTHONUNBUFFERED 1

# Копируем все файлы проекта в каталог /code
COPY . /code
# Set work directory
WORKDIR /code

# Install dependencies
# Копируем файлы poetry.lock и pyproject.toml в каталог /code
COPY poetry.lock pyproject.toml /code/
# Обновляем pip и устанавливаем Poetry версии 1.8.5
RUN pip install --upgrade pip setuptools "poetry==1.8.5"
# Отключаем создание виртуального окружения для Poetry
RUN poetry config virtualenvs.create false
# Устанавливаем зависимости проекта с помощью Poetry из основной группы
RUN poetry install --only main