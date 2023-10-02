.SILENT: 
	include ./.env
#
### Приложение бэк
#
back-git-clone:
	echo "clone repository for: back"
	git clone ${GIT_HOST}:${GIT_REPOSITORY_BACK} -b ${GIT_BRANCH_BACK} ${LOCAL_CODE_PATH_BACK}
#
back-rm-code:
	echo "remove code for: back"
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
### Приложение фронт
#
front-git-clone:
	echo "clone repository for: front"
	git clone ${GIT_HOST}:${GIT_REPOSITORY_FRONT} -b ${GIT_BRANCH_FRONT} ${LOCAL_CODE_PATH_FRONT}
#
front-rm-code:
	echo "remove code for: front"
	rm -rf ${LOCAL_CODE_PATH_FRONT}
#
front-env-copy:
	echo "front-env-copy: skip"
#
front-packages-install:
	echo "front-packages-install: skip"
#
front-migration:
	echo "bfront-migration: skip"
#
### Команды, общие для приложений
#
git-clone:
	make \
		back-git-clone \
		front-git-clone
# 
env-copy:
	make \
		back-env-copy \
		front-env-copy
# 
packages-install:
	make \
		back-packages-install \
		font-packages-install
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
lde: git-clone env-copy up packages-install migration
	echo "Local Docker Environment installed" && \
	echo "Backend: http://127.0.0.1/backend/" && \
	echo "Frontend: http://127.0.0.1/"
