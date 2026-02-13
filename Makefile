.PHONY: up down api-dev api-install logs ps clean

COMPOSE := docker compose -f infra/docker/compose.yml -p kogowybrac

# --- Docker ---

up: ## Start all services
	$(COMPOSE) up -d

down: ## Stop all services
	$(COMPOSE) down

ps: ## Show running services
	$(COMPOSE) ps

logs: ## Tail logs (all services)
	$(COMPOSE) logs -f

logs-api: ## Tail API logs
	$(COMPOSE) logs -f api

rebuild: ## Rebuild and restart
	$(COMPOSE) up -d --build

# --- API (local dev) ---

api-install: ## Install API dependencies
	cd apps/api && npm install

api-dev: ## Run API locally (without Docker)
	cd apps/api && npm run dev

# --- Ingestion (local dev) ---

ingestion-install: ## Install ingestion dependencies
	cd apps/ingestion && pip install -e ".[dev]"

# --- Warehouse (dbt) ---

warehouse-venv: ## Create venv for warehouse
	cd apps/warehouse && python3 -m venv .venv

warehouse-install: ## Install warehouse dependencies (dbt)
	cd apps/warehouse && .venv/bin/pip install -r requirements.txt

warehouse-debug: ## Test dbt connection
	cd apps/warehouse && DB_PORT=5433 .venv/bin/dbt debug --profiles-dir .

warehouse-run: ## Run dbt models
	cd apps/warehouse && DB_PORT=5433 .venv/bin/dbt run --profiles-dir .

warehouse-init-schema: ## Initialize staging schema
	cd apps/warehouse && DB_PORT=5433 .venv/bin/python scripts/init_schema.py

# --- Utilities ---

clean: ## Remove volumes and orphans
	$(COMPOSE) down -v --remove-orphans

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

