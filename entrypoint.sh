#!/bin/bash

set -e

SOURCE_DIR="/opt/evosc"
TARGET_DIR="/home/container"

if [ "$2" = 'esc' ]; then
        if [ ! -f "${TARGET_DIR}/.evosc_seeded" ]; then
                cp -an "${SOURCE_DIR}/." "${TARGET_DIR}/"
                touch "${TARGET_DIR}/.evosc_seeded"
        fi
fi

# we don't want to start EvoSC with root permissions
if [ "$2" = 'esc' -a "$(id -u)" = '0' ]; then
        chown -R evosc ${TARGET_DIR}
        exec su-exec evosc "$0" "$@"
fi

if [ "$2" = 'esc' ]; then
        [ ! -f ${TARGET_DIR}/config/theme.config.json ] && cp ${SOURCE_DIR}/config/default/theme.config.json ${TARGET_DIR}/config/theme.config.json
        [ ! -f ${TARGET_DIR}/config/database.config.json ] && cp ${SOURCE_DIR}/config/default/database.config.json ${TARGET_DIR}/config/database.config.json
        [ ! -f ${TARGET_DIR}/config/server.config.json ] && cp ${SOURCE_DIR}/config/default/server.config.json ${TARGET_DIR}/config/server.config.json

	databaseConfig=()
	databaseConfig+=('.host = '\"${DB_HOST}\"'')
	databaseConfig+=('| .db = '\"${DB_NAME}\"'')
	databaseConfig+=('| .user = '\"${DB_USER}\"'')
	databaseConfig+=('| .password = '\"${DB_PASSWORD}\"'')

        eval jq \'${databaseConfig[@]}\' ${TARGET_DIR}/config/database.config.json > ${TARGET_DIR}/config/database.config.json.tmp
        mv ${TARGET_DIR}/config/database.config.json.tmp ${TARGET_DIR}/config/database.config.json

	serverConfig=()
	serverConfig+=('.ip = '\"${RPC_IP}\"'')
	serverConfig+=('| .port = '\"${RPC_PORT:-5000}\"'')
	serverConfig+=('| .rpc.login = '\"${RPC_LOGIN:-SuperAdmin}\"'')
	serverConfig+=('| .rpc.password = '\"${RPC_PASSWORD:-SuperAdmin}\"'')
	serverConfig+=('| .["default-matchsettings"] = '\"${GAME_SETTINGS:-default.txt}\"'')

        eval jq \'${serverConfig[@]}\' ${TARGET_DIR}/config/server.config.json > ${TARGET_DIR}/config/server.config.json.tmp
        mv ${TARGET_DIR}/config/server.config.json.tmp ${TARGET_DIR}/config/server.config.json

        [ ! -f ${TARGET_DIR}/cache/.setupfinished ] && touch ${TARGET_DIR}/cache/.setupfinished
fi

exec "$@"
