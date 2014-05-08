#!/bin/bash

themesdir="$HOME/.mythtv/themes"

devdir="$themesdir/Barry_dev"
reldir="$themesdir/Barry"

export DROPBOX_UPLOADER_CONFIG_FILE="$HOME/.barryuploader.conf"
uploader="$devdir/dev-stuff/dropbox_uploader.sh"

cols=${COLUMNS:-`tput cols`}
export COLUMNS=${COLUMNS:-$cols}

b_echoright () {
    # (from http://stackoverflow.com/a/2575525)
    # based on a script from http://invisible-island.net/xterm/xterm.faq.html
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    # on my system, the following line can be replaced by the line below it
    echo -en "\033[6n" > /dev/tty
    # tput u7 > /dev/tty    # when TERM=xterm (and relatives)
    IFS=';' read -r -d R -a pos
    stty $oldstty
    # change from one-based to zero based so they work with: tput cup $row $col
    row=$((${pos[0]:2} - 1))    # strip off the esc-[
    col=$((${pos[1]} - 1))
    
    output="$*"
    let width=cols-col
    #echo cols: $cols col: $col output: $* length: ${#output} width: $width
    printf "%${width}s\n" "$output"
}

echo Barry release script
echo devdir: "$devdir"
echo reldir: "$reldir"
echo

echo -n 'getting version number… '
mver=$(echo $(sed -n 's/<!-- barry-version --><value>Barry \([0-9\.]*\)<.*/\1/p' "$devdir/menu-ui.xml"))
tiver1=$(echo $(sed -n 's/<major>\([0-9\.]*\)<.*/\1/p' "$devdir/themeinfo.xml"))
tiver2=$(echo $(sed -n 's/<minor>\([0-9\.]*\)<.*/\1/p' "$devdir/themeinfo.xml"))
tiver3=$(echo $(sed -n 's/<revision>\([0-9\.]*\)<.*/\1/p' "$devdir/themeinfo.xml"))
tiver3=${tiver3:+.$tiver3}
tiver=$tiver1.$tiver2$tiver3

if [ "$mver" != "$tiver" ]
then
    b_echoright error!
    echo ' ! themeinfo.xml & menu-ui.xml disagree'
    echo '   themeinfo.xml says:' "$tiver"
    echo '   menu-ui.xml says:  ' "$mver"
    exit 1
fi

ver=$mver
b_echoright done '('got "$ver"')'

out=
echo -n 'zapping release foler… '
out=$(rm -Rv "$reldir")
b_echoright done '('zapped $(echo "$out"|wc -l)')'

out=
echo -n 'copying… '
out=$(cp -Rv "$devdir" "$reldir")
b_echoright done '('copied $(echo "$out"|wc -l)')'

out=
echo -n 'removing dev-stuff folder… '
out=$(rm -Rv "$reldir/dev-stuff")
b_echoright done '('zapped $(echo "$out"|wc -l)')'

out=
echo -n 'deleting Pixelmator files… '
out=$(find "$reldir" -name '*.pxm' -delete -ls)
b_echoright done '('deleted $(echo "$out"|wc -l)')'

out=
echo -n 'obliterating .DS_Store files… '
out=$(find "$reldir" -name '.DS_Store' -delete -ls)
b_echoright done '('obliterated $(echo "$out"|wc -l)')'

echo -n 'changing theme name from “Barry dev” to “Barry”… '
sed -i '' 's/<name>Barry dev</<name>Barry</' "$reldir/themeinfo.xml"
b_echoright done '('changed')'

echo -n 'updating folder references… '
sed -i '' 's/\/Barry_dev\//\/Barry\//g' "$reldir/customise/"*.sh "$reldir/mainmenu/"*.xml
b_echoright done '('updated')'

echo -n 'applying default customisation set… '
bash "$reldir/customise/customise.sh" release
b_echoright done '('applied')'

zipname=Barry-$ver.zip
zipfile=$themesdir/$zipname
out=
echo -n 'zipping into '$zipname'… '
rm "$zipfile" 2>/dev/null
out=$(cd "$themesdir"; zip -o9r "$zipfile" "Barry")
b_echoright done, $(gdu --si "$zipfile"|cut -f1)B '('zipped $(echo "$out"|wc -l)')'

#echo "$out"|cut -d':' -f2-|sed 's/^ //'|rev|cut -d'(' -f2|sed 's/^ //'|rev > "$devdir/dev-stuff/$zipname.filelist"
echo "$out"|cut -d':' -f2-|sed 's/^ //' > "$devdir/dev-stuff/$zipname.filelist"

echo 'uploading to Dropbox… '
# export COLUMNS=50
"$uploader" -qp upload "$zipfile" "Barry downloads/$zipname" 2>&1 | tr -u '#' '•' 
export COLUMNS=$cols

tput cuu1
tput dl1
tput cuu1
tput dl1
tput el1
tput cr
echo -n 'uploading to Dropbox… '
b_echoright done

rm "$zipfile"

echo -n 'getting link… '
sleep 2
b_echoright $("$uploader" -q share "Barry downloads/$zipname")

echo finished!


