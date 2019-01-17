.PHONY: help welcome certificate clean build start stop install goodbye composer-install composer-update db db-update clear docker-clean
.DEFAULT_GOAL: help

include .env.dist

help:
	@grep -h -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

##
#############################
###     HELP - MAKEFILE     #
#############################
##
##Project
##----------
##

clean:
	@if [ -f "docker/containers/nginx/cert/placeholder" ]; \
	then \
		rm docker/containers/nginx/cert/placeholder; \
	fi

build:
	@printf '\n##################################\n'
	@printf '#     BUILD DOCKER SERVICES      #\n'
	@printf '##################################\n\n'
	docker-compose build

start: ## Start the project
	@printf '\n##################################\n'
	@printf '#    START DOCKER CONTAINERS     #\n'
	@printf '##################################\n\n'
	docker-compose up -d

db:
	@printf '\n##################################\n'
	@printf '#            CREATE DB           #\n'
	@printf '##################################\n'
	docker-compose exec php-fpm bin/console doctrine:database:create --if-not-exists

composer-install:
	@printf '\n##################################\n'
	@printf '#      INSTALL DEPENDENCIES      #\n'
	@printf '##################################\n'
	docker run --rm --interactive --tty \
        --volume $(PWD)/symfony:/app \
        composer install

stop: ## Stop the project
	@printf '\n##################################\n'
	@printf '#     STOP DOCKER CONTAINERS     #\n'
	@printf '##################################\n\n'
	docker-compose stop

restart: stop start ## Restart the project

install: welcome clean .env certificate build start composer-install db goodbye ## Install the project

welcome:
	@printf '##################################\n'
	@printf '#    INSTALL SF STARTER PROJ     #\n'
	@printf '##################################\n'

goodbye:
	@printf '\nPROJECT IS NOW INSTALLED...\n\n'
	@printf '##################################\n'
	@printf '#         READY TO CODE!         #\n'
	@printf '##################################\n\n'

##
##
##Utils
##----------
##

db-update: ## Update database
	@printf '\n##################################\n'
	@printf '#         UPDATE DATABASE        #\n'
	@printf '##################################\n'
	docker-compose exec php-fpm bin/console make:migration
	docker-compose exec php-fpm bin/console doctrine:migrations:migrate

composer-update: ## Update PHP dependencies
	@printf '\n##################################\n'
	@printf '#       UPDATE DEPENDENCIES      #\n'
	@printf '##################################\n'
	docker run --rm --interactive --tty \
        --volume $(PWD)/symfony:/app \
        composer update

clear: ## Clear cache
	@printf '\n##################################\n'
	@printf '#           CLEAR CACHE          #\n'
	@printf '##################################\n'
	docker-compose exec php-fpm bin/console cache:clear --env=dev

docker-clean: ## Stop containers, remove all containers and images
	@printf '\n##################################\n'
	@printf '#         DOCKER CLEANUP         #\n'
	@printf '##################################\n'
	docker stop $$(docker ps -aq) && docker rm $$(docker ps -aq) && docker rmi $$(docker images -q)

certificate: ## Create self-signed certificate
	@if [ ! -f "docker/containers/nginx/cert/selfsigned-cert.key" ]; \
	then \
		echo "##################################"; \
		echo "# CREATE SELF-SIGNED CERTIFICATE #"; \
		echo "##################################"; \
		echo "openssl genrsa -out selfsigned-cert.key 4096"; \
		echo "openssl req -new -x509 -sha256 -subj '/C=FR/ST=Occitanie/L=Montpellier/CN=$(APP_SERVER_ALIAS)' -days 3650 -key selfsigned-cert.key -out selfsigned-cert.crt"; \
		cd docker/containers/nginx/cert; \
		openssl genrsa -out selfsigned-cert.key 4096; \
		openssl req -new -x509 -sha256 -subj '/C=FR/ST=Occitanie/L=Montpellier/CN=$(APP_SERVER_ALIAS)' -days 3650 -key selfsigned-cert.key -out selfsigned-cert.crt; \
	fi

.env: .env.dist
	@if [ !  -f ".env" ]; \
	then \
		echo "cp .env.dist symfony/.env"; \
		cp .env.dist symfony/.env; \
		echo "cp .env.dist .env"; \
		cp .env.dist .env; \
	fi

##