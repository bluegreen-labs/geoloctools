#!/bin/bash

# download the geoid PGM file from
# the geographiclib website
# http://geographiclib.sourceforge.net/1.18/geoid.html
# unzip version egm2008-1, the highest resolution model
# output and run this script to convert the data
# to a simple geotiff, note that a cubic extraction
# can't be done from geotiff - this is a limitation
# with a slight accuracy penalty

gdal_translate -co COMPRESS=LZW -co PREDICTOR=2 \
   -co TILED=YES -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 \
   egm2008-1.pgm egm2008-1.tif
