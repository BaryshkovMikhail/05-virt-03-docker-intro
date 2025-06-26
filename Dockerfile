# Используем официальный образ Nginx
FROM nginx:1.21.1

# Удаляем стандартный index.html
RUN rm /usr/share/nginx/html/index.html

# Копируем наш кастомный index.html в контейнер
COPY index.html /usr/share/nginx/html/

# Опционально: можно указать expose порта
EXPOSE 80

# Команда по умолчанию (уже задана в nginx, но можно оставить явно)
CMD ["nginx", "-g", "daemon off;"]