#!/bin/bash

here=$HOME/.mythtv/themes/Barry_dev/customise

for opt in "$@"
do
    case "$opt" in
        "reload")   reload=1;;
        "release")  release=1;;
        *)          bash "$here/$opt.sh";;
    esac
done

if [ $release ]
then
    bash "$here/colour-blue.sh"
    bash "$here/font-droidsans.sh"
    bash "$here/backdrop-sj_pixelate1.sh"
#     bash "$here/colourbar-off.sh"
fi


if [ $reload ]; then bash "$here/reload-theme.sh"; fi
