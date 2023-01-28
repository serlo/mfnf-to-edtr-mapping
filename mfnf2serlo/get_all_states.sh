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
article_regex="^\* \[\[((Mathe für Nicht-Freaks:|Serlo: EN:) .*)\|.*]]"
heading_regex="^(==*) \[*([^]]*)]* ==*$"
inner_heading_regex="[^\|]*\|(.*)"
while read -r line
do
    if [[ "$line" =~ $article_regex ]]
    then
        title_unesc="${BASH_REMATCH[1]}"
        title="${title_unesc// /_}"
        echo -ne "<li><a href=\"https://de.wikibooks.org/wiki/${title}\">${title_unesc}</a>" >>"$FILENAME"
        ESCAPED_ARTICLE=$(jq "import \"scripts/lib\" as lib; \"$title\" | lib::escape_make" -n -r)
        REVISION=$(scripts/get_revision.sh "$title")
        make articles/$ESCAPED_ARTICLE/$REVISION.json
        if [ "$?" = 0 ]
        then
            echo -ne "&nbsp;<span class=\"status-ok\">ok</span>" >>"$FILENAME"
            echo -ne " <a href=\"https://frontend-git-mfnf-edtr-state-preview-serlo.vercel.app/___edtr_preview?source=https://mfnf.serlo.org/articles/${ESCAPED_ARTICLE}/${REVISION}.json\">Editor-Ansicht</a>" >>"$FILENAME"
        else
            echo -ne "&nbsp;<span class=\"status-error\">error</span>" >>"$FILENAME"
        fi
        echo "</li>" >>"$FILENAME"
    elif [[ "$line" =~ $heading_regex ]]
    then
        echo '</ul>' >>"$FILENAME"
        heading_level=${#BASH_REMATCH[1]}
        inner_heading=${BASH_REMATCH[2]}
        if [[ "$inner_heading" =~ $inner_heading_regex ]]
        then
            echo "<h$heading_level>${BASH_REMATCH[1]}</h$heading_level>" >>"$FILENAME"
        else
            echo "<h$heading_level>$inner_heading</h$heading_level>" >>"$FILENAME"
        fi
        echo '<ul>' >>"$FILENAME"
    fi
done <sitemap
echo '</ul>' >>"$FILENAME"
echo "<span>Zuletzt aktualisiert: $(date)</span>" >>"$FILENAME"
echo '</body>' >>"$FILENAME"
