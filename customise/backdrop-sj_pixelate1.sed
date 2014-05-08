s/<!-- barry-backdrop --><filename>backdrops\/.*\.png/<!-- barry-backdrop --><filename>backdrops\/sj_pixelate1\.png/
s/str BackgroundPixmap=backdrops\/.*\.png/str BackgroundPixmap=backdrops\/sj_pixelate1\.png/
s/<state name="BARRY_BACKDROP_\(.*\)" from="BARRY_MENUSTATE_."/<state name="BARRY_BACKDROP_\1" from="BARRY_MENUSTATE_E"/
s/<state name="BARRY_BACKDROP_PIXELATE" from="BARRY_MENUSTATE_."/<state name="BARRY_BACKDROP_PIXELATE" from="BARRY_MENUSTATE_1"/
