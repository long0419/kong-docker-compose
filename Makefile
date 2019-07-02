kong_project_name=api-gateway
kong_ui_project_name=kong-dashboard
kong_compose_file = kong/docker-compose.yml
kong_ui_compose_file = kong-ui/docker-compose.yml
kong_volume = ${kong_project_name}_kong-data
kong_ui_volume = ${kong_ui_project_name}_konga-data

run:
	docker network inspect kong-net &>/dev/null || docker network create kong-net
	$(call START_SERVICE, ${kong_project_name}, ${kong_compose_file})
	$(call START_SERVICE, ${kong_ui_project_name}, ${kong_ui_compose_file})

clean:
	$(call STOP_SERVICE, ${kong_project_name}, ${kong_compose_file},${kong_volume})
	$(call STOP_SERVICE, ${kong_ui_project_name}, ${kong_ui_compose_file}, ${kong_ui_volume})

define START_SERVICE
	docker-compose -p ${1} -f ${2} stop
	docker-compose -p ${1} -f ${2} rm -f
	docker-compose -p ${1} -f ${2} up -d
	sleep 10
	docker-compose -p ${1} -f ${2} stop
	sleep 5
	docker-compose -p ${1} -f ${2} start
	sleep 15
endef

define STOP_SERVICE
	docker-compose -p ${1} -f ${2} stop
	docker-compose -p ${1} -f ${2} rm -f
	docker volume rm ${3} -f
endef
