.PHONY: help install build-dev build-prod start-dev start-prod down clear cache-clear migrate migrate-refresh logs-dev logs-prod shell-dev shell-prod npm-dev npm-build

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
	docker-compose -f docker-compose.dev.yml exec backend composer install
	docker-compose -f docker-compose.dev.yml exec backend npm install
	docker-compose -f docker-compose.dev.yml exec backend cp .env.example .env
	docker-compose -f docker-compose.dev.yml exec backend php artisan key:generate
	@echo '${GREEN}Установка завершена${RESET}'

build-dev: ## Build для разработки
	docker-compose -f docker-compose.dev.yml up --build
	@echo '${GREEN}Среда разработки запущена${RESET}'
	@echo '${YELLOW}Приложение доступно на http://localhost:8000${RESET}'

build-prod: ## Build для production
	docker-compose -f docker-compose.prod.yml up --build
	@echo '${GREEN}Production среда запущена${RESET}'

start-dev: ## Запуск в dev
	docker-compose -f docker-compose.dev.yml up --remove-orphans
	@echo '${GREEN}Среда разработки запущена${RESET}'
	@echo '${YELLOW}Приложение доступно на http://localhost:8000${RESET}'

start-prod: ## Запуск в production
	docker-compose -f docker-compose.prod.yml up --remove-orphans
	@echo '${GREEN}Production среда запущена${RESET}'

down: ## Остановка контейнеров
	docker-compose -f docker-compose.dev.yml down
	docker-compose -f docker-compose.prod.yml down
	@echo '${GREEN}Контейнеры остановлены${RESET}'

clear: ## Очистка всех кешей и временных файлов через контейнер
	docker-compose -f docker-compose.dev.yml exec backend php artisan cache:clear
	docker-compose -f docker-compose.dev.yml exec backend php artisan config:clear
	docker-compose -f docker-compose.dev.yml exec backend php artisan route:clear
	docker-compose -f docker-compose.dev.yml exec backend php artisan view:clear
	docker-compose -f docker-compose.dev.yml exec backend php artisan optimize:clear
	@echo '${GREEN}Кеш очищен${RESET}'

cache-clear: ## Очистка только кеша через контейнер
	docker-compose -f docker-compose.dev.yml exec backend php artisan cache:clear
	@echo '${GREEN}Кеш очищен${RESET}'

migrate: ## Запуск миграций через контейнер
	docker-compose -f docker-compose.dev.yml exec backend php artisan migrate
	@echo '${GREEN}Миграции выполнены${RESET}'

migrate-refresh: ## Пересоздание базы данных и запуск миграций через контейнер
	docker-compose -f docker-compose.dev.yml exec backend php artisan migrate:fresh --seed
	@echo '${GREEN}База данных пересоздана${RESET}'

logs-dev: ## Просмотр логов dev
	docker-compose -f docker-compose.dev.yml logs -f

logs-prod: ## Просмотр логов prod
	docker-compose -f docker-compose.prod.yml logs -f

shell-dev: ## Доступ к shell dev контейнера php
	docker-compose -f docker-compose.dev.yml exec backend bash

shell-prod: ## Доступ к shell prod контейнера php
	docker-compose -f docker-compose.prod.yml exec backend bash
