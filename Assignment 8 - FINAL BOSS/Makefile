# =========================
# IP SPECTRE - Makefile
# =========================

APP_NAME=ip-spectre
AWS_REGION?=eu-west-1
BACKEND_DIR=backend
FRONTEND_DIR=frontend
TERRAFORM_DIR=terraform
BACKEND_IMAGE=$(APP_NAME)-backend
FRONTEND_IMAGE=$(APP_NAME)-frontend
PYTHON?=python

.PHONY: help install run-backend test docker-build-backend docker-run-backend docker-build-frontend docker-run-frontend tf-init tf-apply tf-destroy clean

help:
	@echo "IP SPECTRE - Available commands:"
	@echo ""
	@echo "Local backend:"
	@echo "  make install             Install backend Python dependencies"
	@echo "  make run-backend         Run backend API locally (uvicorn)"
	@echo "  make test                Run backend tests"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build-backend   Build backend Docker image"
	@echo "  make docker-run-backend     Run backend Docker image (port 8080)"
	@echo "  make docker-build-frontend  Build frontend Docker image"
	@echo "  make docker-run-frontend    Run frontend Docker image (port 3000->80)"
	@echo ""
	@echo "Terraform:"
	@echo "  make tf-init        Terraform init"
	@echo "  make tf-apply       Terraform apply"
	@echo "  make tf-destroy     Terraform destroy"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean          Remove caches"

# -------- Local --------

install:
	$(PYTHON) -m pip install -r $(BACKEND_DIR)/requirements.txt

run-backend:
	$(PYTHON) -m uvicorn backend.app.main:app --reload --host 0.0.0.0 --port 8080

test:
	pytest $(BACKEND_DIR)/tests

# -------- Docker --------

docker-build-backend:
	docker build -t $(BACKEND_IMAGE) -f $(BACKEND_DIR)/Dockerfile $(BACKEND_DIR)

docker-run-backend:
	docker run -it --rm -p 8080:8080 --env-file .env $(BACKEND_IMAGE)

docker-build-frontend:
	docker build -t $(FRONTEND_IMAGE) -f $(FRONTEND_DIR)/Dockerfile $(FRONTEND_DIR)

docker-run-frontend:
	docker run -it --rm -p 3000:80 $(FRONTEND_IMAGE)

# -------- Terraform --------

tf-init:
	cd $(TERRAFORM_DIR) && terraform init

tf-apply:
	cd $(TERRAFORM_DIR) && terraform apply

tf-destroy:
	cd $(TERRAFORM_DIR) && terraform destroy

# -------- Cleanup --------

clean:
	-rm -rf **/__pycache__
	-rm -rf $(BACKEND_DIR)/*.log $(BACKEND_DIR)/.pytest_cache
