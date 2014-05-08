#!/bin/bash

themesdir="$HOME/.mythtv/themes"

devdir="$themesdir/Barry_dev"

previewdir="$devdir/themepreviews"

echo 'Barry preview maker script'
echo "previews go in $previewdir"
echo
previews=( $(sed -n 's/.*<thumbnail name=".*">themepreviews\/\(.*\.png\)<.*/\1/p' "$devdir/themeinfo.xml") )

declare -i i=0
for preview in "${previews[@]}"
do
    echo "preview $i: $preview"
    let i++
done

read -p ' - numbers to exclude, separated by spaces [2]: ' -a excludes
echo
excludes=${excludes:-2}

for exclude in "${excludes[@]}"
do
    echo "excluding ${previews[exclude]}"
    previews[exclude]=''
done
echo

declare -i i=0
for preview in "${previews[@]}"
do
    if [ "x$preview" == "x" ]; then continue; fi
    read -p "about to take ${preview}…"
    screencapture "$previewdir/$preview"
    let i++
done
echo

echo 'done!'
