#!/usr/bin/env bash

CONTAINER_IMAGE="eg_sshd"
CONTAINER_NAME_PREFIX="sshd_"

SSH_PUBLIC_PORT="2222"

# Find all server ips excluding localhost
ALL_IPS=$(ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1 }' | shuf)

echo "Found IPs:"
echo "${ALL_IPS}"
echo ""
echo "Checking IPs one by one"

# Looking for first ip without connections
for CURRENT_IP in $ALL_IPS; do
    USAGES=$(netstat -tap | grep "${CURRENT_IP}" | wc -l)

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
