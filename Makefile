.PHONY: help install build-dev build-prod dev prod down clear cache-clear migrate migrate-refresh logs shell npm-dev npm-build test lint docker-clean

# Цвета для вывода
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

# Помощь
help: ## Показать эту справку
	@echo ''
	@echo 'Доступные команды:'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ''

install: ## Первоначальная установка проекта
	@echo '${GREEN}Установка зависимостей...${RESET}'
	composer install
	npm install
	cp .env.example .env
	php artisan key:generate
	@echo '${GREEN}Установка завершена${RESET}'

build-dev: ## Build для разработки
	docker-compose -f docker-compose.dev.yml up --build
	@echo '${GREEN}Среда разработки запущена${RESET}'
	@echo '${YELLOW}Приложение доступно на http://localhost:8000${RESET}'

build-prod: ## Build для production
	docker-compose -f docker-compose.prod.yml up --build
	@echo '${GREEN}Production среда запущена${RESET}'

dev: ## Запуск в режиме разработки
	docker-compose -f docker-compose.dev.yml up -d
	@echo '${GREEN}Среда разработки запущена${RESET}'
	@echo '${YELLOW}Приложение доступно на http://localhost:8000${RESET}'

prod: ## Запуск в production
	docker-compose -f docker-compose.prod.yml up -d
	@echo '${GREEN}Production среда запущена${RESET}'

down: ## Остановка контейнеров
	docker-compose -f docker-compose.dev.yml down
	docker-compose -f docker-compose.prod.yml down
	@echo '${GREEN}Контейнеры остановлены${RESET}'

clear: ## Очистка всех кешей и временных файлов
	php artisan cache:clear
	php artisan config:clear
	php artisan route:clear
	php artisan view:clear
	php artisan optimize:clear
	@echo '${GREEN}Кеш очищен${RESET}'

cache-clear: ## Очистка только кеша
	php artisan cache:clear
	@echo '${GREEN}Кеш очищен${RESET}'

migrate: ## Запуск миграций
	php artisan migrate
	@echo '${GREEN}Миграции выполнены${RESET}'

migrate-refresh: ## Пересоздание базы данных и запуск миграций
	php artisan migrate:fresh --seed
	@echo '${GREEN}База данных пересоздана${RESET}'

logs: ## Просмотр логов
	docker-compose -f docker-compose.dev.yml logs -f

shell: ## Доступ к shell контейнера php
	docker-compose -f docker-compose.dev.yml exec backend bash

restart: down dev ## Перезапуск контейнеров
	@echo '${GREEN}Контейнеры перезапущены${RESET}'
