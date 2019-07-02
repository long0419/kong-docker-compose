
kong_compose = kong/docker-compose.yml
kong_ui_compose = kong-ui/docker-compose.yml

run:
	docker network inspect kong-net &>/dev/null || docker network create kong-net
	$(call START_SERVICE, ${kong_compose})
	$(call START_SERVICE, ${kong_ui_compose})

clean:
	$(call STOP_SERVICE, ${kong_compose})
	$(call STOP_SERVICE, ${kong_ui_compose})

define START_SERVICE
	docker-compose -f ${1} stop
	docker-compose -f ${1} rm -f
	docker-compose -f ${1} up -d
	sleep 10
	docker-compose -f ${1} stop
	sleep 5
	docker-compose -f ${1} start
	sleep 15
endef

define STOP_SERVICE
	docker-compose -f ${1} stop
	docker-compose -f ${1} rm -f
	docker volume prune -f
endef
