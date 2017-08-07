#!/usr/bin/env bash

set -e

WAIT_SECONDS=300
DOCKER_PID_PATH="{{.State.Pid}}"
DOCKER_STARTED_AT_PATH="{{.State.StartedAt}}"

for CONTAINER_ID in $(docker ps -q); do
    echo "Checking container ${CONTAINER_ID}"

    # Fetching container info from docker
    PID=$(docker inspect -f "${DOCKER_PID_PATH}" "${CONTAINER_ID}")
    STARTED_AT=$(docker inspect -f "${DOCKER_STARTED_AT_PATH}" "${CONTAINER_ID}")

    # Defining timestamps
    STARTED_TS=$(date -u -d "${STARTED_AT}" +"%s")
    CURRENT_TS=$(date -u +"%s")

    echo "Started at: ${STARTED_AT}"

    # Counting established connections to container
    COUNT=$(nsenter -t "${PID}" -n netstat | grep ESTABLISHED | wc -l)

    echo "Active connections: ${COUNT}"

    if [ "${COUNT}" == "0" ]; then
        SECONDS_SINCE_START=$(($CURRENT_TS - $STARTED_TS))
        echo "Seconds since start passed: ${SECONDS_SINCE_START}"

        if [ "$SECONDS_SINCE_START" -gt "$WAIT_SECONDS" ]; then
            echo "Killing container"

            docker stop $CONTAINER_ID > /dev/null
            docker rm $CONTAINER_ID > /dev/nul
        fi
    fi
done;
