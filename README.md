# SlideRule_methow
Investigating ICESat-2 SlideRule products for snow depth measurements in the Western U.S.

### Here I use SlideRule for ICESat-2 data access. SlideRule parameters:
* nsidc-s3
* release = 004
* length = 40
* step = 20
* confidence = 4 (only high confidence photons will be included)
* land class: atl08_ground
* iterations = 1
* spread = 20
* pe count = 10
* window = 3
* sigma = 5
* projection: global

I compare ICESat-2 sliderule ATL06 (with atl08 ground classification) elevation point data to an airborne lidar DEM commissioned by the Washington DNR in 2018. This lidar data was accessed through the WA DNR lidar data portal. It was transformed from the NAVD88 geoid to the WGS84 ellipsoid. In the future I would like to coregister them using either command line asp (Ames Stereo Pipeline) tools such as pc_align or the wrapper around this function created by David Shean (dem_coreg https://github.com/dshean/demcoreg)
