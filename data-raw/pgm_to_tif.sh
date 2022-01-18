#!/bin/bash

# download the geoid PGM file from
# the geographiclib website
# http://geographiclib.sourceforge.net/1.18/geoid.html
# http://sf.net/projects/geographiclib/files/geoids-distrib/egm2008-1.tar.bz2/download
# unzip version egm2008-1 + xml, the highest resolution model
# output and run this script to convert the data
# to a simple geotiff, note that a cubic extraction
# can't be done from geotiff - this is a limitation
# with a slight accuracy penalty

gdal_translate -a_ullr 0 90 360 -90 egm2008-1.pgm tmp.tif

gdalwarp -s_srs "+proj=longlat +ellps=WGS84"\
 -t_srs WGS84 \
 tmp.tif test.tif\
 -wo SOURCE_EXTRA=1000 \
 --config CENTER_LONG 0

gdal_translate -co COMPRESS=LZW -co PREDICTOR=2 \
   -co TILED=YES -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 \
    test.tif ../inst/exdata/egm2008-1.tif

rm test.tif tmp.tif
