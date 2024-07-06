#!/usr/bin/env bash

nice -n 10 php /usr/src/artisan schedule:run --verbose --no-interaction
