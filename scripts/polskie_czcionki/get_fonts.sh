#!/bin/sh

cat urls.txt | grep '.zip' | sort | xargs wget -c
exit
mkdir fonts
ls *.zip | xargs -L 1 unzip -d ./fonts -o
rm *.zip
find ./fonts/ -type f ! -name '*.ttf' -exec rm -v '{}' \;
