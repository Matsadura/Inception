COMPOSE	= ./srcs/docker-compose.yml
USER_DATA = /home/zzaoui/data
DB_DATA = $(USER_DATA)/mariadb
WP_DATA  = $(USER_DATA)/wordpress

all: setup up

setup:
	@sudo mkdir -p $(DB_DATA) $(WP_DATA)
	@sudo chown -R 33:33 $(WP_DATA)
	@openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ./srcs/requirements/nginx/tools/ssl.key \
  -out ./srcs/requirements/nginx/tools/ssl.crt \
  -subj "/CN=localhost"

up:
	@docker compose -f $(COMPOSE) up -d --build

down:
	@docker compose -f $(COMPOSE) down

clean: down
	@docker system prune -a -f

fclean: clean
	@sudo rm -rf $(USER_DATA)
	@docker volume rm $(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf ./srcs/requirements/nginx/tools/ssl.crt ./srcs/requirements/nginx/tools/ssl.key

re: fclean all

logs:
	@docker compose -f $(COMPOSE) logs -f

info:
	@docker ps


.PHONY = all up down clean re fclean logs info setup
