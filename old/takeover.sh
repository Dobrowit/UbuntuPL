#!/bin/bash

sudo chown -vR $USER:$USER $1
chmod -vR + $1

find $1 -type f -exec chmod -v =rw '{}' \;
find $1 -type d -exec chmod -v =rwx '{}' \;
find $1 -type f -name '*.sh' -exec chmod -v +x '{}' \;
