# Mountain snow depth retrievals from customized processing of ICESat-2 satellite laser altimetry
Investigating ICESat-2 SlideRule products for snow depth measurements in the Western U.S.

This repository contains code, data, and figures used for Besso, Shean, and Lundquist 2023. We calculate snow depth by differencing ICESat-2 ATL06 processed with Sliderule Earth from airborne lidar at two study sites. We calculate error metrics by comparing the ICESat-2 snow depths to various other snow depth measurements, such as SNOTEL and CDEC site data and Airborne Snow Observatory, Inc airborne snow on lidar flights.  

![alt text](/tuolumne_basin/figures/Fig1.jpeg)

Notebooks and Descriptions (folder: notebooks):
* **Data_Acess_SR-ATL06.ipynb**   Written by Tyler Sutterly for ICESat-2 Hackweek 2022 hosted by UW's e-science institute. Use widgets to request and download ICESat-2 data using SlideRule. See below for selected parameters in the widget drop down menus. Prior to running this notebook, I created a polygon of the outline of the DEM to pass into SlideRule for my ICESat-2 data download. This notebook then saves the ICESat-2 geodataframe to a geojson for later use.
* **HB-Methow_analysis.ipynb**    The meat of my analysis. Reads in the ICESat-2 geojson created in the Data_Access notebook as a geodataframe. Identifies and gets snow depth data for all SNOTEL sites within a 60km radius from the center of the study site (using the polygon mentioned above - made from the outline of the DEM) and uses these sites to determine snow-on and snow-off dates for the ICESat-2 data. It also pulls in a csv of Citizen Science Observations (https://communitysnowobs.org/). It reads in the 1m resolution DEM, samples the DEM's elevation at each ICESat-2 point, and finds the difference between these elevations. The difference in snow off elevations is consider a bias/offset, and the median of these values is used to correct the DEM sampled elevations to better align with ICESat-2. The winter differences are assumed to be due to snow depth. This notebook then subsets the data to only low slope (<10 degrees slope) areas and plots the ICESat-2 snow depths compared to the Snotel network snow depths. It also plots the heatmaps representing the distribution of differences relative to slope and elevation.
* **Snotel_IS2.ipynb**    An old notebook I pulled code from to make the Methow_analysis notebook. 
* **Subset_pointcloud.ipynb**      This is used to create a smaller subset of the ICESat-2 and DEM for use in testing the output of point cloud alignment using the AMES StereoPipeline's pc_align tool. This notebook reads in snow-off ICESat-2 data and clips it to a rectangle within the study area. It then reads in a rasterio window of the DEM and saves that window to a new file. The 1m resolution and 10m resolution files are processed.
* **create_lidar_polygon.ipynb**    Uses code from David Shean's Grand Mesa analysis notebook to create a polygon of the outline of a raster data file, in this case the irregular outline of the Methow Valley DEM. This is the polygon that is passed to SlideRule to download ICESat-2 data within it's outline. 

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


