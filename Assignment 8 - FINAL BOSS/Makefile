# =========================
# IP SPECTRE - Makefile
# =========================

APP_NAME=ip-spectre
AWS_REGION=eu-west-1
TERRAFORM_DIR=terraform
DOCKERFILE=docker/Dockerfile

.PHONY: help install run scan docker-build docker-run tf-init tf-apply tf-destroy clean

help:
	@echo "IP SPECTRE - Available commands:"
	@echo ""
	@echo "Local:"
	@echo "  make install        Install Python dependencies"
	@echo "  make run            Run CLI locally"
	@echo "  make scan           Scan IP locally (--scan)"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build   Build Docker image"
	@echo "  make docker-run     Run CLI in Docker with AWS access"
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
	pip install -r cli/requirements.txt

run:
	python cli/cli.py

scan:
	python cli/cli.py --scan

# -------- Docker --------

docker-build:
	docker build -t $(APP_NAME) -f $(DOCKERFILE) .

docker-run:
	docker run -it \
		-e AWS_REGION=$(AWS_REGION) \
		-v ~/.aws:/home/appuser/.aws:ro \
		$(APP_NAME)

# -------- Terraform --------

tf-init:
	cd $(TERRAFORM_DIR) && terraform init

tf-apply:
	cd $(TERRAFORM_DIR) && terraform apply

tf-destroy:
	cd $(TERRAFORM_DIR) && terraform destroy

# -------- Cleanup --------

clean:
	rm -rf cli/__pycache__ cli/*.log
