.PHONY: help build zip lock tests clean deploy

# Configuration
LAMBDA_FOLDER?=src/lambda_ec2
ZIP_OUTPUT?=lambda_function.zip
PYTHON_VERSION?=3.13
PLATFORM?=x86_64-manylinux2014
TERRAFORM_DIR?=terraform

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

lock: ## Lock dependencies
	@cd $(LAMBDA_FOLDER) && uv lock

tests: lock ## Run tests
	@cd $(LAMBDA_FOLDER) && uv run pytest -vv

clean: ## Remove build artifacts
	rm -rf $(LAMBDA_FOLDER)/packages $(ZIP_OUTPUT) $(LAMBDA_FOLDER)/requirements.txt

build: clean tests ## Build Lambda deployment package
	@cd $(LAMBDA_FOLDER) && \
	uv lock && \
	uv export --frozen --no-dev --no-editable -o requirements.txt && \
	uv pip install \
		--no-installer-metadata \
		--no-compile-bytecode \
		--python-platform $(PLATFORM) \
		--python $(PYTHON_VERSION) \
		--target packages \
		-r requirements.txt

zip: build ## Create deployment ZIP archive
	@cd $(LAMBDA_FOLDER)/ && \
	zip -qr ../../$(ZIP_OUTPUT) packages/ && \
	zip -q ../../$(ZIP_OUTPUT) main.py

deploy: zip ## Deploy to AWS via Terraform
	@cd $(TERRAFORM_DIR) && \
	terraform init && \
	terraform apply -auto-approve
