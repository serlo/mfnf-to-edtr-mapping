#!/usr/bin/env bash

ESCAPED_ARTICLE=$(jq "import \"scripts/lib\" as lib; \"$1\" | lib::escape_make" -n -r)
REVISION=$(scripts/get_revision.sh "$1")
make articles/$ESCAPED_ARTICLE/$REVISION.json
