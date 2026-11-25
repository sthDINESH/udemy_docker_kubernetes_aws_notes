#!/usr/bin/env bash

set -e

NETWORK_NAME="mongodb"
MONGODB_CONTAINER="mongo-db"
MONGO_EXPRESS_CONTAINER="mongo-express"
MONGO_VOLUME="mongo-database"

stop_containers() {
    for container in "$MONGO_EXPRESS_CONTAINER" "$MONGODB_CONTAINER"; do
        if docker container inspect "$container" >/dev/null 2>&1; then
            docker container stop "$container"
        fi
    done
}

remove_network() {
    if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
        docker network rm "$NETWORK_NAME"
    fi
}

start() {
    # Create a custom docker bridge network for containers to communicate
    if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
        docker network create "$NETWORK_NAME"
    fi

    # Launch a MongoDB container with volume mount and attach it to custom network
    docker container run -d --rm \
        --name "$MONGODB_CONTAINER" \
        -v "$MONGO_VOLUME:/data/db" \
        --network "$NETWORK_NAME" \
        -e MONGO_INITDB_ROOT_USERNAME=root \
        -e MONGO_INITDB_ROOT_PASSWORD=password123 \
        mongo:7.0

    # Launch mongo-express container and attach it to custom network
    docker container run -d --rm \
        -p 8081:8081 \
        --network "$NETWORK_NAME" \
        -e "ME_CONFIG_MONGODB_URL=mongodb://root:password123@${MONGODB_CONTAINER}:27017/?authSource=admin" \
        --name "$MONGO_EXPRESS_CONTAINER" \
        mongo-express
}

stop() {
    stop_containers
    remove_network
}

remove() {
    stop_containers
    remove_network

    if docker volume inspect "$MONGO_VOLUME" >/dev/null 2>&1; then
        docker volume rm "$MONGO_VOLUME"
    fi
}

case "${1:-}" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    remove)
        remove
        ;;
    *)
        echo "Usage: $0 {start|stop|remove}" >&2
        exit 1
        ;;
esac

