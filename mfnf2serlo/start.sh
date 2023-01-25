#!/bin/sh

BASE=. make
crond
/usr/sbin/nginx -g "daemon off;"
