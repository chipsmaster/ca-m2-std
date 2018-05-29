help:
	@echo
	@echo "Available commands:"
	@echo
	@echo "  check      : Check and print final docker compose configuration."
	@echo "  build      : (Re-)build containers."
	@echo "  run        : Run containers in this terminal."
	@echo "  clear      : Clear containers and associated volumes."
	@echo "  setup      : Setup magento files"
	@echo "  install    : Install magento."
	@echo "  bash       : Start a shell on web container with normal user."
	@echo "  cron       : Run system cron jobs added by magento"
	@echo "  help       : Display this help."
	@echo


.env:
	./config.sh

check: .env
	docker version
	docker-compose version
	docker-compose config

build: check
	docker-compose build

run: check
	docker-compose up

setup:
	docker-compose exec -u magento web m2-setup.sh

install:
	docker-compose exec -u magento web m2-setup.sh 1
	docker-compose exec -u magento web m2-install.sh

bash:
	docker-compose exec -u magento -e COLUMNS="$(shell tput cols)" -e LINES="$(shell tput lines)" web bash

cron:
	docker-compose exec -u magento web m2-cron.sh

clear:
	docker-compose down --volumes

