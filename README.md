# User Management CRUD

CRUD-интерфейс для управления пользователями, реализованный на Laravel 10 и Vue 3.

## Технологический стек

- Backend: Laravel 10, MySQL, PHP 8.2
- Frontend: Vue 3, Vuetify 3, Vite
- Инфраструктура: Docker, Nginx

## Основные функции

- CRUD операции с пользователями
- Пагинация
- Валидация данных
- Логирование действий

## Развертывание для разработки

1. Клонируйте репозиторий:
```bash
git clone <repository-url>
cd <project-directory>
```

2. Выполните первоначальную настройку:
```bash
make install
```

3. Запустите среду разработки:
```bash
make build-dev
```

4. Запустите миграции:
```bash
make migrate
```

Приложение будет доступно по адресу: `http://localhost:8000`

## Развертывание для продакшена

1. Настройте переменные окружения для продакшена

2. Соберите продакшен образы:
```bash
make build-prod
```

3. Запустите продакшен среду:
```bash
make start-prod
```

## Основные команды Make

### Разработка
- `make install` - Первоначальная установка
- `make build-dev` - Сборка и запуск для разработки
- `make start-dev` - Запуск среды разработки
- `make down` - Остановка всех контейнеров
- `make shell-dev` - Доступ к shell контейнера

### База данных
- `make migrate` - Запуск миграций
- `make migrate-refresh` - Пересоздание базы данных

### Кэш
- `make clear` - Очистка всех кэшей
- `make cache-clear` - Очистка кэша приложения

### Логи
- `make logs-dev` - Просмотр логов разработки
- `make logs-prod` - Просмотр продакшен логов

## API Endpoints

### Users
- `GET /api/v1/users` - Список пользователей
- `POST /api/v1/users` - Создание пользователя
- `GET /api/v1/users/{id}` - Получение пользователя
- `PUT /api/v1/users/{id}` - Обновление пользователя
- `DELETE /api/v1/users/{id}` - Удаление пользователя
