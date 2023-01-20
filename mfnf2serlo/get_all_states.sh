#!/usr/bin/env bash

FILENAME=$1
cat >"$FILENAME" <<EOF
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<ul>
EOF
article_regex="^\* \[\[(Mathe für Nicht-Freaks: .*)\|.*]]"
while read -r line
do
    if [[ "$line" =~ $article_regex ]]
    then
        title_unesc="${BASH_REMATCH[1]}"
        title="${title_unesc// /_}"
        echo -ne "<li><a href=\"https://de.wikibooks.org/wiki/${title}\">${title_unesc}</a>" >>"$FILENAME"
        ./get_state.sh "$title"
        if [ "$?" = 0 ]
        then
            echo -ne "&nbsp;<span class=\"status-ok\">ok</span>" >>"$FILENAME"
        else
            echo -ne "&nbsp;<span class=\"status-error\">error</span>" >>"$FILENAME"
        fi
        echo "</li>" >>"$FILENAME"
    fi
done <sitemap
echo '</ul>' >>"$FILENAME"
echo '</body>' >>"$FILENAME"
