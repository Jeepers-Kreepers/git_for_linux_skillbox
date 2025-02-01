# Отчет

 

1. Установливаю Docker и Docker Compose:

    1. **Устанавливаю Docker**

        ```bash
        sudo apt-get update								# Обновление списка пакетов linux.

        sudo apt-get install ca-certificates curl		# ca-certificates обеспечивает \
        												# безопасность при скачивании ключа.
        												# curl используется для скачивания \
        												# GPG-ключа Docker.

        sudo install -m 0755 -d /etc/apt/keyrings		# создает каталог /etc/apt/keyrings,
        												# и устанавливает соответствующие права
        												# доступа, чтобы в нем можно было
        												# хранить GPG-ключи для репозиториев.

        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        # скачивает GPG-ключ Docker из официального источника и сохраняет его в файл docker.asc в каталоге /etc/apt/keyrings. Этот ключ используется для проверки подлинности пакетов Docker.

        sudo chmod a+r /etc/apt/keyrings/docker.asc
        # устанавливает права пользователей читать файл GPG-ключа, что необходимо для работы менеджера пакетов APT

        # Добавление репозитория в источники APT:
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        # Добавляет официальный репозиторий Docker в список репозиториев APT. Cобирает всю необходимую информацию (архитектура, кодовое имя Ubuntu, путь к ключу) и добавляет ее в файл /etc/apt/sources.list.d/docker.list. 
        # sudo tee позволяет записать вывод в файл, и не выводить его в терминал (благодаря > /dev/null).

        sudo apt-get update
        ```

        :docker: Устанавливаю Компонеты:

        * **Docker Engine:**  Основной компонент для запуска контейнеров.
        * **Docker CLI:**  Инструмент командной строки для управления Docker.
        * **Containerd:**  Среда выполнения контейнеров, используемая Docker.
        * **Docker Buildx Plugin:**  Расширенные возможности для сборки образов.
        * **Docker Compose Plugin:**  Инструмент для управления многоконтейнерными приложениями.

        ```bash
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        ```

        :docker: Проверяю, что docker установлен

        ```bash
        sudo docker run hello-world

        # Видим приветствие Docker
        Hello from Docker!
        This message shows that your installation appears to be working correctly.
        ```
    2. **Устанавливаю Docker Compose**

        Загружаю свежую версию Docker и сохраняю исполняемый файл в `/usr/local/bin/docker-compose` 

        ```bash
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose/
        ```

        Устанавливаю права на исполнение загруженного файла

        ```bash
        sudo chmod +x /usr/local/bin/docker-compose
        ```

        Проверяю, что версия docker-compose верная

        ```bash
        docker-compose --version

        # Вывод в консоль:
        Docker Compose version v2.23.0
        ```
    3. Настраиваю Docker для работы без прав root (добавление пользователя в группу docker).

        ```bash
        sudo groupadd docker				# создаю группу с именем docker
        sudo usermod -aG docker $USER		# добавляю текущего пользователя


        docker run hello-world				# пробую запустить контейнер без sudo

        # Вижу, что контейнер запущен:
        Hello from Docker!
        This message shows that your installation appears to be working correctly.
        ```
2. Создаю репозиторий на GitHub для своего проекта.

    * [https://github.com/Jeepers-Kreepers/git_for_linux_skillbox.git](https://github.com/Jeepers-Kreepers/git_for_linux_skillbox.git)
    * Клонирую удаленный репозиторий в локальный
    * делаю первый `commit`  и `push`  с файлом `.gitignore` 

      *  `git commit -am "first commit .gitignore"` 
      * Далее работаю в IDE Pycharm (пользуюсь UI)
3. **Простая программа на Python**:

    * Программа выводит в консоль график с кривой разгона двигателя постоянного тока на основе его классической математической модели.

      Уравнение математической модели двигателя постоянного тока:

      $\frac{d\omega(t)}{dt} + (\frac{k_m k_e}{J R})w = \frac{k_m}{J R}U$,  где  $\frac{J R}{k_m k_e} = T_m$ - Постоянная времени (с)

      Файл `model_dc_motor.py` :

      ```python
      import sympy                                        # Импортирует библиотеку SymPy для символьных вычислений.
      from sympy.plotting import plot                     # Импортирует функцию plot для построения графиков.

      U = sympy.symbols('U')                              # Определяет символ U (напряжение).
      T_m = sympy.symbols('T_m')                          # Определяет символ T_m (Константа / Постоянная времени).
      t = sympy.symbols('t')                              # Определяет символ t (время).
      k_e = sympy.symbols('k_e', positive=True)			# Опр k_e > 0 коэффициент обратной ЭДС
      omega = sympy.Function('omega')                     # Определяет функцию omega(t) - угловая скорость rad/s

      ode = sympy.Eq(omega(t).diff(t),
                     U/(k_e*T_m) - omega(t)/T_m)          # Определяет уравнение для угловой скорости

      # решение уравнения (определение изменения угловой скорости dc двигателя)
      ode_sol = sympy.dsolve(ode, omega(t), ics={omega(0): 0})    # Решает уравнение исходя из начальных условий
      ode_num = ode_sol.subs({U: 8, T_m: 0.08, k_e: 0.5})         # Преобразует символьные выражения в числовые

      if __name__ == '__main__':
          t0 = float(input("Введите начальное время (ex = 0): "))
          t_end = float(input("Введите конечное время (ex = 0.5): "))
          plot(ode_num.rhs, (t, t0, t_end))     # Построение графика угловой скорости в зависимости от времени
      ```

      Что происходит в программе:

      1. **Определение символов:**

          *  `U`  — напряжение.
          *  `T_m`  — константа / постоянная времени.
          *  `t`  — время.
          *  `k_e`  — коэффициент обратной ЭДС (положительный).
          *  `omega(t)`  — угловая скорость как функция времени.
      2. **Дифференциальное уравнение:**

          * Уравнение задается как:  
             $\frac{d\omega(t)}{dt} = \frac{U}{k_e T_m} - \frac{\omega(t)}{T_m}$
          * Это уравнение описывает динамику угловой скорости двигателя постоянного тока.
      3. **Решение дифференциального уравнения:**

          * Используется метод `sympy.dsolve`  для решения уравнения.
          * Начальное условие: \($\omega(0) = 0$\).
      4. **Подстановка численных значений:**

          * Подставляются значения:

            * \(U = 8\),
            * \(T_m = 0.08\),
            * \(k_e = 0.5\).
      5. **Построение графика:**

          * Строится график решения \($\omega(t)$\) для \($t \in [интервал.задается.пользователем]$\).

      #### Результат:

      * График показывает, как угловая скорость двигателя изменяется со временем при заданных параметрах.
4. Создаю Docker-образа для программы:

    1. Создаю Dockerfile для сборки образа, включающего программу и зависимости.

        ```dockerfile
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
        ```
    2. Собираю Docker-образ из созданного Dockerfile.

        ```python
        docker build -t model_dc_motor . 
        ```
    3. Убеждаюсь, что имя образа `model_dc_motor`  присутствует в списке по запросу `docker images` 

        ```python
        :~/skillbox_git_linux$ docker images
        REPOSITORY       TAG              IMAGE ID       CREATED          SIZE
        model_dc_motor   latest           7bc00f1e9939   23 seconds ago   1.14GB
        ```
5. Запускаю и тестирую Python-приложение в Docker-контейнере:

    1. Запускаю Docker-контейнер из созданного образа.

        ```python
        docker run -it model_dc_motor /bin/bash/
        ```
    2. Проверяю, что файл `model_dc_motor.py`  работает корректно внутри контейнера и график строится

        ```python
        :~/skillbox_git_linux$ docker run -it model_dc_motor /bin/bash
        root@39757d6b9a91:/code# python3 model_dc_motor.py

        Введите начальное время (ex = 0): 0
        Введите конечное время (ex = 0.5): 0.5
             16 |                                .......................
                |                       .........
                |                  .....
                |                ..
                |             ...
                |            /
                |          ..
                |         /
                |        /
                |       /
              8 |------/------------------------------------------------
                |     .
                |
                |    .
                |   .
                |
                |
                | .
                |
              0 |_______________________________________________________
                 0                          0.25                       0.5

        ```
6. Работа с Docker Compose:

    1. Создаю `docker-compose.yml` , который запускает Docker-контейнер с программой.

        ```yml
        services:
          angular_motor_speed:
            image: model_dc_motor
            # command: python3 model_dc_motor.py / вызовет ошибку, т.к файл будет закрыт до того как пользователь введет данные
            tty: true                 # дает возможность подключиться к терминалу контейнера
            stdin_open: true          # дает возможность отправлять команды в контейнер
        ```

        Приведенная последовательность команд в файле `docker-compose.yml`  нужна для того , чтобы появилась возможность произвести запуск файла `model_dc_motor.py` в интерактивном режиме из терминала локального компьютера. Файл будет требовать ввода данных пользователя. При этом директива `command`  в подобной конфигурации сервиса не будет работать. Возникнет ошибка `EOF when reading a line`  , т.к. поток ввода данных закончится раньше, чем мы ожидаем. Нужно, чтобы Docker не запускал `model_dc_motor.py` автоматически при старте контейнера. Вместо этого мы будем запускать её интерактивно через `docker compose exec` .  
        Последовательность команд в этом случае должна быть следующая:

        ```bash
        # Запуск контейнера в фоновом режиме
        docker compose up -d

        # Подключение к контейнеру в интерактивном режиме
        docker compose exec angular_motor_speed bash

        # Теперь внутри контейнера можно запустить файл model_dc_motor.py
        python3 model_dc_motor.py
        ```

        Для того, чтобы не вводить все команды вручную можно использовать следующий `bash`  скрипт.

         `launch.sh` 

        ```bash
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
        ```
    2. Убеждаюсь, что Docker Compose позволяет запустить контейнер и **bash скрипт** отрабатывает корректно:

        ```bash
        :~/skillbox_git_linux$ ./launch.sh
        [+] Running 1/0
         ✔ Container skillbox_git_linux-angular_motor_speed-1  Running                                                                                                                 0.0s 
        Введите начальное время (ex = 0): 0
        Введите конечное время (ex = 0.5): 0.5
             16 |                                .......................
                |                       .........
                |                  .....
                |                ..
                |             ...
                |            /
                |          ..
                |         /
                |        /
                |       /
              8 |------/------------------------------------------------
                |     .
                |
                |    .
                |   .
                |
                |  .
                |
                | .
                |
              0 |_______________________________________________________
                 0                          0.25                       0.5
        Работа скрипта завершена.
        ```
    3.  
7. Оформляю проект на GitHub:

    1. Помещаю `Dockerfile`  и `docker-compose.yml`  в репозиторий на GitHub.
    2. Подготавливаю `README.md` , описывающий проект и процесс запуска программы с помощью Docker и Docker Compose.

 

В данном отчете предоставлены: 

* ссылка GitHub-репозиторий, содержащий `Dockerfile` , `docker-compose.yml` , `README.md`  и тестовое приложение `model_dc_motor.py` с комментариями, объясняющими каждую инструкцию:
  * [https://github.com/Jeepers-Kreepers/git_for_linux_skillbox.git](https://github.com/Jeepers-Kreepers/git_for_linux_skillbox.git)
* выводы в терминал, демонстрирующие успешный запуск и работу программы `model_dc_motor.py`  в Docker-контейнере;
* описание шагов по установке и настройке Docker и Docker Compose.
