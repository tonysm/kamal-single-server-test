#!/usr/bin/env bash

if [ $# -gt 0 ]; then
    exec "$@"
else
    php artisan migrate --force

    exec /init
fi
