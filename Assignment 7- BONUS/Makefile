.PHONY: help build up down logs clean test k8s-deploy k8s-delete helm-install helm-uninstall

# Variables
DOCKER_COMPOSE = docker-compose
KUBECTL = kubectl
HELM = helm
NAMESPACE = taskmanager

build: ## Build all Docker images
	$(DOCKER_COMPOSE) build

up: ## Start all services with Docker Compose
	$(DOCKER_COMPOSE) up -d

down: ## Stop all services
	$(DOCKER_COMPOSE) down

logs: ## Show logs from all services
	$(DOCKER_COMPOSE) logs -f

clean: ## Remove all containers, volumes, and images
	$(DOCKER_COMPOSE) down -v --rmi all

test: ## Test the application
	@echo "Testing backend health..."
	@curl -f http://localhost:5001/health || exit 1
	@echo "Testing frontend..."
	@curl -f http://localhost:3000 || exit 1
	@echo "All tests passed!"

k8s-deploy: ## Deploy to Kubernetes
	$(KUBECTL) apply -f k8s/

k8s-delete: ## Delete Kubernetes deployment
	$(KUBECTL) delete -f k8s/

k8s-status: ## Check Kubernetes deployment status
	$(KUBECTL) get all -n $(NAMESPACE)

helm-install: ## Install with Helm
	$(HELM) install taskmanager ./helm/taskmanager

helm-upgrade: ## Upgrade Helm release
	$(HELM) upgrade taskmanager ./helm/taskmanager

helm-uninstall: ## Uninstall Helm release
	$(HELM) uninstall taskmanager

helm-template: ## Show Helm template output
	$(HELM) template taskmanager ./helm/taskmanager