.DEFAULT_GOAL := help

ENV="staging"

.PHONY: init
init: ## Initialize Terraform Cloud. e.g. $ make init ENV=stg
	@terraform -chdir=envs/$(ENV) init

.PHONY: plan
plan: ## Run plan. e.g. $ make plan ENV=stg
	@terraform -chdir=envs/$(ENV) plan

.PHONY: apply
apply: ## Run apply. e.g. $ make plan ENV=stg
	@terraform -chdir=envs/$(ENV) apply

.PHONY: fmt
fmt: ## Format code
	@terraform fmt -recursive

.PHONY: lint
lint: ## Lint code
	@tflint --recursive --config $(shell pwd)/.tflint.hcl

.PHONY: help
help: ## Show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
