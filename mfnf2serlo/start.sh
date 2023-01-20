#!/bin/sh

BASE=. make
/usr/sbin/nginx -g "daemon off;"
