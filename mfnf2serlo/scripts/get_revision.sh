#!/bin/sh

set -e
URL_ENC=$(echo $1 | jq -r -R @uri)
REVISION=$(curl -qgsf "https://de.wikibooks.org/api/rest_v1/page/title/$URL_ENC" | jq ".items[0].rev")
REVISION=$(echo "$REVISION" | grep -e "^[0-9][0-9]*$" || echo "error")
echo $REVISION
