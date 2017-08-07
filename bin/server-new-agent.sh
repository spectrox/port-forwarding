#!/usr/bin/env bash

set -e

CONTAINER_IMAGE="eg_sshd"
CONTAINER_NAME_PREFIX="sshd_"

SSH_PUBLIC_PORT="2222"

# Find all server ips excluding localhost
ALL_IPS=$(ip route get 8.8.8.8 | awk '/src/ { print $NF }')

echo "Found IPs:"
echo "${ALL_IPS}"
echo ""
echo "Checking IPs one by one"

PORTS_MATCH=$(echo "$@" | sed 's/ /|/')

# Looking for first ip without connections
for CURRENT_IP in $ALL_IPS; do
    USAGES=$(netstat -tapn | egrep "${CURRENT_IP}\:($PORTS_MATCH)" | wc -l)

    echo "IP ${CURRENT_IP} has ${USAGES} usages"

    if [ "${USAGES}" == "0" ]; then
        echo ""
        echo "We have a winner!"
        echo "Using IP: ${CURRENT_IP}"

        break
    fi

    CURRENT_IP=""
done

if [ "${CURRENT_IP}" == "" ]; then
    echo "All IPs are already in use"

    exit 1
fi

PORT_PUBLISH_COMMAND="-p ${CURRENT_IP}:${SSH_PUBLIC_PORT}:22"
PORT_MAPPING=""

for ARGUMENT in $@; do
    PORT_PUBLISH_COMMAND="${PORT_PUBLISH_COMMAND} -p ${CURRENT_IP}:${ARGUMENT}:10${ARGUMENT}"
    PORT_MAPPING="${PORT_MAPPING}\n${ARGUMENT}:10${ARGUMENT}"
done

echo ""
echo "Port publishing command: ${PORT_PUBLISH_COMMAND}"
echo ""

echo "Starting container ${CONTAINER_NAME_PREFIX}${CURRENT_IP}"

docker run -d -v ~/.ssh/id_rsa.pub:/client/.ssh/authorized_keys \
    $PORT_PUBLISH_COMMAND \
    --name "${CONTAINER_NAME_PREFIX}${CURRENT_IP}" \
    "${CONTAINER_IMAGE}" > /dev/null

echo ""
echo "You can start ssh tunnel to ${CURRENT_IP}"
echo -e "Port mapping:${PORT_MAPPING}"
