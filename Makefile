
BASE_DATA_DIR				= /home/$(USER)/data
MARIADB_DIR					= $(BASE_DATA_DIR)/mariadb
WORDPRESS_DIR				= $(BASE_DATA_DIR)/wordpress

COMPOSE_FILE_ROUTE	= ./srcs/docker-compose.yml

all: up

up:
		mkdir -p $(MARIADB_DIR)
		mkdir -p $(WORDPRESS_DIR)
		sudo docker compose -f $(COMPOSE_FILE_ROUTE) up -d --build

down:
		sudo docker compose -f $(COMPOSE_FILE_ROUTE) down

clean: down
	if [ $$(sudo docker container ls -qa | wc -l) -gt 0 ]; then \
		sudo docker container rm -f $$(sudo docker container ls -qa); \
	fi
	if [ $$(sudo docker image ls -qa | wc -l) -gt 0 ]; then \
		sudo docker image rm -f $$(sudo docker image ls -qa); \
	fi
	if [ $$(sudo docker network ls --filter type=custom -q | wc -l) -gt 0 ]; then \
    sudo docker network rm $$(sudo docker network ls --filter type=custom -q); \
	fi
	sudo rm -rf $(MARIADB_DIR)
	sudo rm -rf $(WORDPRESS_DIR)

fclean: clean
		if [ $$(sudo docker volume ls -q | wc -l) -gt 0 ]; then \
			sudo docker volume rm $$(sudo docker volume ls -q); \
		fi
		rm -rf $(BASE_DATA_DIR)

re: fclean all

.PHONY: all up down clean fclean re
