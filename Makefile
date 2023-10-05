.SILENT:
#
include .env
#
### Hosts
#
traefik-hosts:
	echo "127.0.0.1  ${LOCAL_HOSTNAME_TRAEFIK}"
	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_TRAEFIK}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_TRAEFIK}' | sudo tee -a "${HOSTS}"
# mailhog-hosts:
# 	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_MAILHOG}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_MAILHOG}' | sudo tee -a "${HOSTS}"
# kibana-hosts:
# 	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_KIBANA}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_KIBANA}' | sudo tee -a "${HOSTS}"
pma-hosts:
	echo "127.0.0.1  ${LOCAL_HOSTNAME_PMA}"
	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_PMA}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_PMA}' | sudo tee -a "${HOSTS}"
# redis-commander-hosts:
# 	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_REDIS_COMMANDER}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_REDIS_COMMANDER}' | sudo tee -a "${HOSTS}"
back-hosts:
	echo "127.0.0.1  ${LOCAL_HOSTNAME_BACK}"
	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_BACK}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_BACK}' | sudo tee -a "${HOSTS}"
#
### Главный сервис бэка
#
back-git-clone:
	echo "Clone repository: back"
	git clone ${GIT_REPOSITORY_BACK} -b ${GIT_BRANCH_BACK} ${LOCAL_CODE_PATH_BACK}
#
back-rm-code:
	echo "Remove code: back"
	rm -rf ${LOCAL_CODE_PATH_BACK}
#
back-env-copy:
	echo "back-env-copy: skip"
#
back-packages-install:
	echo "back-packages-install: skip"
#
back-migration:
	echo "back-migration: skip"
#
### Заготовка под фронт
#
front-git-clone:
	echo "front-git-clone: skip"
	# echo "Clone repository: front"
	# git clone ${GIT_REPOSITORY_FRONT} -b ${GIT_BRANCH_FRONT} ${LOCAL_CODE_PATH_FRONT}
#
front-rm-code:
	echo "front-rm-code: skip"
	# echo "Remove code: front"
	# rm -rf ${LOCAL_CODE_PATH_FRONT}
#
front-env-copy:
	echo "front-env-copy: skip"
#
front-packages-install:
	echo "front-packages-install: skip"
#
front-migration:
	echo "front-migration: skip"
#
### Команды, общие для приложений
#
git-clone:
	make \
		back-git-clone \
		front-git-clone
# 
rm-code:
	make \
		back-rm-code \
		front-rm-code
# 
env-copy:
	make \
		back-env-copy \
		front-env-copy
# 
packages-install:
	make \
		back-packages-install \
		front-packages-install
# 
migration:
	make \
		back-migration \
		front-migration
#
### Управляющие команды
# Добавляем хосты
hosts:
	make \
		back-hosts \
		pma-hosts \
		traefik-hosts
# Cоздание сети для контейнеров
network:
	docker network inspect traefik_net >/dev/null 2>&1 || docker network create traefik_net
#
build:
	docker compose build
#
#build-npm:
#	docker compose -f docker-compose-npm.yml build --no-cache
#
up: network
	docker compose up -d
#
restart:
	docker compose restart
#
down:
	docker compose down
# Удаляет volumes. Использовать с осторожностью!
down-v:
	- docker compose down -v --rmi local
# Очистить кеш докер сборщика
clean-build-cache:
	- yes | docker builder prune -a
#
clean: clean-build-cache
	- docker compose down --rmi local
#
lde: hosts git-clone env-copy network build up packages-install migration
	echo "Local Docker Environment installed" && \
	echo "Traefik: http://${LOCAL_HOSTNAME_TRAEFIK}:8080/" && \
	echo "Phpmyadmin: http://${LOCAL_HOSTNAME_PMA}/" && \
	# echo "Frontend: http://${LOCAL_HOSTNAME_FRONT}/" && \
	echo "Backend: http://${LOCAL_HOSTNAME_BACK}/backend/"
	