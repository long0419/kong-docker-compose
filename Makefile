project_name=api-gateway
kong_compose = kong/docker-compose.yml
kong_ui_compose = kong-ui/docker-compose.yml
kong_volume = ${project_name}_kong-data
kong_ui_volume = ${project_name}_konga-data

run:
	docker network inspect kong-net &>/dev/null || docker network create kong-net
	$(call START_SERVICE, ${kong_compose})
	$(call START_SERVICE, ${kong_ui_compose})

clean:
	$(call STOP_SERVICE, ${kong_compose},${kong_volume})
	$(call STOP_SERVICE, ${kong_ui_compose}, ${kong_ui_volume})

define START_SERVICE
	docker-compose -p ${project_name} -f ${1} stop
	docker-compose -p ${project_name} -f ${1} rm -f
	docker-compose -p ${project_name} -f ${1} up -d
	sleep 10
	docker-compose -p ${project_name} -f ${1} stop
	sleep 5
	docker-compose -p ${project_name} -f ${1} start
	sleep 15
endef

define STOP_SERVICE
	docker-compose -p ${project_name} -f ${1} stop
	docker-compose -p ${project_name} -f ${1} rm -f
	docker volume rm ${2} -f
endef
