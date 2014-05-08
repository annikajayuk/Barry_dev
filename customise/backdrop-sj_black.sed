s/<!-- barry-backdrop --><filename>backdrops\/.*\.png/<!-- barry-backdrop --><filename>backdrops\/sj_black\.png/
s/str BackgroundPixmap=backdrops\/.*\.png/str BackgroundPixmap=backdrops\/sj_black\.png/
s/<state name="BARRY_BACKDROP_\(.*\)" from="BARRY_MENUSTATE_."/<state name="BARRY_BACKDROP_\1" from="BARRY_MENUSTATE_E"/
s/<state name="BARRY_BACKDROP_NONE" from="BARRY_MENUSTATE_."/<state name="BARRY_BACKDROP_NONE" from="BARRY_MENUSTATE_1"/
