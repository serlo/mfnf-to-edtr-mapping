#!/bin/sh

cd /var/www/mfnf2serlo

rm -rf articles
rm -f index.html

BASE=. make
