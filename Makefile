.SILENT:

include .env
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
#
build:
	docker compose build
	# docker compose build && docker compose -f docker-compose-npm.yml build
#
#build-npm:
#	docker compose -f docker-compose-npm.yml build --no-cache
#
up:
	docker compose up -d
#
restart:
	docker compose restart
#
down:
	docker compose down
#
# Очистить кеш докер сборщика
clean-build-cache:
	- yes | docker builder prune -a
#
clean: clean-build-cache
	- docker compose down --rmi local
#
lde: git-clone env-copy build up packages-install migration
	echo "Local Docker Environment installed" && \
	echo "Phpmyadmin: http://127.0.0.1/pma/" && \
	echo "Backend: http://127.0.0.1/backend/" && \
	echo "Frontend: http://127.0.0.1/"
