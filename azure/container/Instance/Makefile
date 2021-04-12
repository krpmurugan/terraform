.PHONY: init
init:
	terraform init

.PHONY: plan
plan:
	terraform plan

.PHONY: apply
apply: validate
	terraform apply --auto-approve

.PHONY: format
format:
	terraform fmt

.PHONY: validate
validate:
	terraform validate

.PHONY: destroy
destroy:
	terraform destroy --auto-approve

.PHONY: refresh
refresh:
	terraform refresh

.PHONY: checkov
checkov:
	checkov --directory .