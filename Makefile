help: ## display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
.PHONY: help

basic: ### basic
	@ansible-playbook -i inventory playbook.yml --tags basic
.PHONY: basic

reset_trader: ### reset_trader
	@ansible-playbook -i inventory playbook.yml --tags reset_trader
.PHONY: reset_trader

setup_trader: ### setup_trader
	@ansible-playbook -i inventory playbook.yml --tags setup_trader
.PHONY: setup_trader

reset_center: ### reset_center
	@ansible-playbook -i inventory playbook.yml --tags reset_center
.PHONY: reset_center

reset_db: ### reset_db
	@ansible-playbook -i inventory playbook.yml --tags reset_db
.PHONY: reset_db

setup_center: ### setup_center
	@ansible-playbook -i inventory playbook.yml --tags setup_center
.PHONY: setup_center

install: ### install
	@python3 -m pip install ansible ansible-lint
