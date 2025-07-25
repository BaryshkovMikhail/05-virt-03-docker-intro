# Домашнее задание к занятию 4 «Оркестрация группой Docker контейнеров на примере Docker Compose» - Барышков Михаил

## Задача 1

Сценарий выполнения задачи:
- Установите docker и docker compose plugin на свою linux рабочую станцию или ВМ.
- Если dockerhub недоступен создайте файл /etc/docker/daemon.json с содержимым: ```{"registry-mirrors": ["https://mirror.gcr.io", "https://daocloud.io", "https://c.163.com/", "https://registry.docker-cn.com"]}```
- Зарегистрируйтесь и создайте публичный репозиторий  с именем "custom-nginx" на https://hub.docker.com (ТОЛЬКО ЕСЛИ У ВАС ЕСТЬ ДОСТУП);
- скачайте образ nginx:1.21.1;
- Создайте Dockerfile и реализуйте в нем замену дефолтной индекс-страницы(/usr/share/nginx/html/index.html), на файл index.html с содержимым:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```
- Соберите и отправьте созданный образ в свой dockerhub-репозитории c tag 1.0.0 (ТОЛЬКО ЕСЛИ ЕСТЬ ДОСТУП). 
- Предоставьте ответ в виде ссылки на https://hub.docker.com/<username_repo>/custom-nginx/general .

## Решение 1

https://hub.docker.com/repository/docker/nastya2005/my_nginx/general

## Задача 2
1. Запустите ваш образ custom-nginx:1.0.0 командой docker run в соответвии с требованиями:
- имя контейнера "ФИО-custom-nginx-t2"
- контейнер работает в фоне
- контейнер опубликован на порту хост системы 127.0.0.1:8080
2. Не удаляя, переименуйте контейнер в "custom-nginx-t2"
3. Выполните команду ```date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8080  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html```
4. Убедитесь с помощью curl или веб браузера, что индекс-страница доступна.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.


## Решение 2

1. 
```bash
docker run -d --name baryshkov-custom-nginx-t2 -p 127.0.0.1:8080:80 nastya2005/my_nginx:1.0.0
```
![img1](img/img1.png)

2.

```bash
docker rename baryshkov-custom-nginx-t2 custom-nginx-t2
```
![img2](img/img2.png)

3. 
![img3](img/img3.png)

4. 
![img4](img/img4.png)

## Задача 3
1. Воспользуйтесь docker help или google, чтобы узнать как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2".
2. Подключитесь к контейнеру и нажмите комбинацию Ctrl-C.
3. Выполните ```docker ps -a``` и объясните своими словами почему контейнер остановился.
4. Перезапустите контейнер
5. Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.
6. Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
7. Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".
8. Запомните(!) и выполните команду ```nginx -s reload```, а затем внутри контейнера ```curl http://127.0.0.1:80 ; curl http://127.0.0.1:81```.
9. Выйдите из контейнера, набрав в консоли  ```exit``` или Ctrl-D.
10. Проверьте вывод команд: ```ss -tlpn | grep 127.0.0.1:8080``` , ```docker port custom-nginx-t2```, ```curl http://127.0.0.1:8080```. Кратко объясните суть возникшей проблемы.
11. * Это дополнительное, необязательное задание. Попробуйте самостоятельно исправить конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. [пример источника](https://www.baeldung.com/linux/assign-port-docker-container)
12. Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

## Решение 3

1. 2. 3. 
![img5](img/img5.png)

❗ После этого контейнер остановится, потому что attach привязывает процесс к текущей консоли, и Ctrl+C отправляет сигнал завершения (SIGINT) основному процессу — nginx. А так как он завершился, Docker считает, что работа контейнера закончена.

🧠 Пояснение:  Контейнер остановился, потому что после Ctrl+C, основной процесс (nginx) был завершен. Docker считает, что контейнер выполнил свою работу и остановился.

4. 5. 6. 7.
![img6](img/img6.png)
![img7](img/img7.png)
![img8](img/img8.png)
8.

![img9](img/img9.png)
![img10](img/img10.png)

🔴 Проблема:  Вы изменили порт Nginx внутри контейнера на 81, но контейнер всё ещё отображает порт 80 наружу (8080:80). То есть: 

    Контейнер слушает 81 , но
    Хост пробрасывает 8080 → 80 (внутри контейнера) .
     

Поэтому команда curl http://127.0.0.1:8080 не работает, т.к. внутри контейнера никто не слушает порт 80.

11. 
```bash
docker stop custom-nginx-t2
docker run -d --name custom-nginx-t2 -p 127.0.0.1:8080:81 nastya2005/my_nginx:1.0.0
```

12.
```bash 
docker rm -f custom-nginx-t2
```

## Задача 4


- Запустите первый контейнер из образа ***centos*** c любым тегом в фоновом режиме, подключив папку  текущий рабочий каталог ```$(pwd)``` на хостовой машине в ```/data``` контейнера, используя ключ -v.
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив текущий рабочий каталог ```$(pwd)``` в ```/data``` контейнера. 
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```.
- Добавьте ещё один файл в текущий каталог ```$(pwd)``` на хостовой машине.
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.


В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

## Решение 4

```bash
docker run -d --name centos-container -v $(pwd):/data centos:centos7.9.2009 tail -f /dev/null
```

```bash
docker run -d --name debian-container -v $(pwd):/data debian tail -f /dev/null
```

```bash
docker exec -it centos-container bash
```
![img11](img/img11.png)

```bash
echo "Это файл из CentOS" > /data/centos_file.txt
exit
```

```bash
echo "Это файл с хоста" > ./host_file.txt
```

```bash
ls -la /data
cat /data/centos_file.txt
cat /data/host_file.txt
```

![img12](img/img12.png)

## Задача 5

1. Создайте отдельную директорию(например /tmp/netology/docker/task5) и 2 файла внутри него.
"compose.yaml" с содержимым:
```
version: "3"
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
"docker-compose.yaml" с содержимым:
```
version: "3"
services:
  registry:
    image: registry:2

    ports:
    - "5000:5000"
```

И выполните команду "docker compose up -d". Какой из файлов был запущен и почему? (подсказка: https://docs.docker.com/compose/compose-application-model/#the-compose-file )

2. Отредактируйте файл compose.yaml так, чтобы были запущенны оба файла. (подсказка: https://docs.docker.com/compose/compose-file/14-include/)

3. Выполните в консоли вашей хостовой ОС необходимые команды чтобы залить образ custom-nginx как custom-nginx:latest в запущенное вами, локальное registry. Дополнительная документация: https://distribution.github.io/distribution/about/deploying/
4. Откройте страницу "https://127.0.0.1:9000" и произведите начальную настройку portainer.(логин и пароль адмнистратора)
5. Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше local  окружение. Перейдите на вкладку "stacks" и в "web editor" задеплойте следующий компоуз:

```
version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
```
6. Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", выберите контейнер с nginx и нажмите на кнопку "inspect". В представлении <> Tree разверните поле "Config" и сделайте скриншот от поля "AppArmorProfile" до "Driver".

7. Удалите любой из манифестов компоуза(например compose.yaml).  Выполните команду "docker compose up -d". Прочитайте warning, объясните суть предупреждения и выполните предложенное действие. Погасите compose-проект ОДНОЙ(обязательно!!) командой.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод, файл compose.yaml , скриншот portainer c задеплоенным компоузом.


## Решение 5

![img13](img/img13.png)

❓ Какой из файлов был запущен? 

    Ответ:  compose.yaml 
     

💡 Объяснение: 

Согласно документации Docker Compose : 

    По умолчанию Docker Compose ищет файлы в следующем порядке:
        compose.yaml (предпочтительный формат)
        docker-compose.yml
        docker-compose.yaml
         
     

Файл compose.yaml имеет наивысший приоритет , поэтому он используется по умолчанию.

![img14](img/img14.png)

```bash
docker ps | grep registry
```

```bash 
docker tag nastya2005/my_nginx:1.0.0 localhost:5000/custom-nginx
docker push localhost:5000/custom-nginx
```
![img15](img/img15.png)
![img16](img/img16.png)
![img17](img/img17.png)
![img19](img/img18.png)
![img19](img/img19.png)
![img20](img/img20.png)

```bash
rm compose.yaml
```

![img21](img/img20.png)

💡 Объяснение: 

Поскольку вы удалили compose.yaml, который содержал определение сервисов, но оставили docker-compose.yaml, Docker не может понять, какие именно сервисы вы хотите запускать. Он видит старые контейнеры, но не может связать их с текущим проектом. 

```bash
docker compose down
```

Эта команда: 

    - остановит и удалит контейнеры
    - удалит сети, созданные проектом
    - очистит volumes (если указан флаг --volumes)
     