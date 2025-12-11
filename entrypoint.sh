#!/bin/bash

set -e

# we don't want to start EvoSC with root permissions
if [ "$2" = 'esc' -a "$(id -u)" = '0' ]; then
	chown -R evosc /home/container/esc
	exec su-exec evosc "$0" "$@"
fi

if [ "$2" = 'esc' ]; then
	[ ! -f /home/container/config/theme.config.json ] && cp /home/container/config/default/theme.config.json /home/container/config/theme.config.json
	[ ! -f /home/container/config/database.config.json ] && cp /home/container/config/default/database.config.json /home/container/config/database.config.json
	[ ! -f /home/container/config/server.config.json ] && cp /home/container/config/default/server.config.json /home/container/config/server.config.json

	databaseConfig=()
	databaseConfig+=('.host = '\"${DB_HOST}\"'')
	databaseConfig+=('| .db = '\"${DB_NAME}\"'')
	databaseConfig+=('| .user = '\"${DB_USER}\"'')
	databaseConfig+=('| .password = '\"${DB_PASSWORD}\"'')

	eval jq \'${databaseConfig[@]}\' /home/container/config/database.config.json > /home/container/config/database.config.json.tmp
	mv /home/container/config/database.config.json.tmp /home/container/config/database.config.json

	serverConfig=()
	serverConfig+=('.ip = '\"${RPC_IP}\"'')
	serverConfig+=('| .port = '\"${RPC_PORT:-5000}\"'')
	serverConfig+=('| .rpc.login = '\"${RPC_LOGIN:-SuperAdmin}\"'')
	serverConfig+=('| .rpc.password = '\"${RPC_PASSWORD:-SuperAdmin}\"'')
	serverConfig+=('| .["default-matchsettings"] = '\"${GAME_SETTINGS:-default.txt}\"'')

	eval jq \'${serverConfig[@]}\' /home/container/config/server.config.json > /home/container/config/server.config.json.tmp
	mv /home/container/config/server.config.json.tmp /home/container/config/server.config.json

	[ ! -f /home/container/cache/.setupfinished ] && touch /home/container/cache/.setupfinished
fi

exec "$@"
