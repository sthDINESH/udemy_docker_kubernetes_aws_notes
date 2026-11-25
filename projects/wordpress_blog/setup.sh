#!/usr/bin/env bash

set -e

stop_containers() {
    for container in blog-wordpress blog-phpmyadmin db; do
        if docker container inspect "$container" >/dev/null 2>&1; then
            docker container stop "$container"
        fi
    done
}

remove_network() {
    if docker network inspect blog >/dev/null 2>&1; then
        docker network rm blog
    fi
}

start() {
    # Create a custom docker bridge network for containers to communicate
    if ! docker network inspect blog >/dev/null 2>&1; then
        docker network create blog
    fi

    # Launch a MariaDB container with volume mount and attach it to custom network
    docker container run -d \
        -v blog-database:/var/lib/mysql \
        --rm \
        --network blog \
        -e MARIADB_ROOT_PASSWORD=password123 \
        --name db \
        mariadb

    # Launch phpMyAdmin container and attach it to custom network
    docker container run -d \
        --rm \
        -p 9090:80 \
        --network blog \
        -e PMA_HOST=db \
        --name blog-phpmyadmin \
        phpmyadmin

    # Launch a WordPress container and attach it to custom network
    docker container run -d --rm \
        -p 9091:80 \
        --network blog \
        -v blog-wordpress:/var/www/html \
        --name blog-wordpress \
        wordpress
}

stop() {
    stop_containers
    remove_network
}

remove() {
    stop_containers
    remove_network

    for volume in blog-database blog-wordpress; do
        if docker volume inspect "$volume" >/dev/null 2>&1; then
            docker volume rm "$volume"
        fi
    done
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

