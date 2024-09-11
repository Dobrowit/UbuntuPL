#!/bin/sh

cat lista_url.txt | grep '.zip' | sort | xargs wget -c
mkdir fonts
ls *.zip | xargs -L 1 unzip -d ./fonts -o
rm *.zip
find ./fonts/ -type f ! -name '*.ttf' -exec rm -v '{}' \;
