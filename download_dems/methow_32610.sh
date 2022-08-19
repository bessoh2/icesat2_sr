## Originally from Eli Schwat, supplied February 23rd 2022: https://github.com/elischwat/hsfm-geomorph/blob/master/download-dems/baker/create_baker_reference.sh

#! /bin/bash

# Download these files from the WA DNR LIDAR portal. We use all the tiles available to get maximum coverage.
# methow_basin_2018_dtm_0.tif
# ...
# methow_basin_2018_dtm_38.tif

# Navigate to a folder containing only these downloaded .tif files
cd Documents/Documents_Grad/Research/IDS_statewide/data/lidar/methow/dtm/
fn_list=$(ls *.tif)

# Activate environment containing gdal tools
conda activate dtm_reproj

# Convert from survey ft. to meters, outputting all tiff files with suffix _m added
parallel "gdal_calc.py --co COMPRESS=LZW --co TILED=YES --co BIGTIFF=IF_SAFER --NoDataValue=-9999 --calc 'A*0.3048' -A {} --outfile {.}_m.tif" ::: $fn_list

# Reproject from ESRI:102749 to EPSG:26910, with suffix _utm added.
parallel "gdalwarp -co COMPRESS=LZW -co TILED=YES -co BIGTIFF=IF_SAFER -dstnodata -9999 -r cubic -s_srs ESRI:102749 -t_srs EPSG:26910 {} {.}_utm.tif" ::: *_m.tif

# Activate Ames Stereo Pipeline environment
conda deactivate
conda activate asp

# Transform from NAVD88 datum to WGS84 ellipsoid, no suffix is added
parallel "dem_geoid --reverse-adjustment {}" ::: *_m_utm.tif

# Activate environment containing gdal
conda deactivate
conda activate datum_reproj

# Manually edit the metadata (doesn't automatically update with above step) from 26910 to 32610, adds suffix -adj
parallel "gdal_edit.py -a_srs EPSG:32610 {}" ::: *_m_utm-adj.tif

# Activate environment containing Ames StereoPipeline
conda deactivate
conda activate asp

# Mosaic the DEMs
dem_mosaic *_m_utm-adj.tif -o methow_basin_2018_dtm_combined_32610_1m.tif

# Activate env containing gdalwarp
conda deactivate
conda activate datum_reproj

# Make a low resolution version
gdalwarp -tr 10 10 -r cubic methow_basin_2018_dtm_combined_32610_1m.tif methow_basin_2018_dtm_combined_32610_12m.tif
