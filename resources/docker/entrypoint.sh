#!/usr/bin/env bash

set -e

if [ $# -gt 0 ]; then
    exec "$@"
else
    php artisan migrate --force

    exec /init
fi
