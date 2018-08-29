# Coordinate transformation for mapping  

## Introduction

This repository is an example how couple of strings could be transformed into spatial data in three steps. In example we will use some XY coordinates of soil science survey holes dug in Poland (eg. Profile: Bolków Ap, Coordinates: E: 16° 09' 9.8'';N: 50° 58' 0.4''). 
.   

## Step 1 - Working with strings in R

There is a lot of usefull string manipulation methods implemented in R. It is usefull to check the Base R package content, there are helpfull functions to be found like 'gsub' which can be used to remove white spaces and unwanted symbols from string like north ("N"). Another great site to study is string R toutorial (https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html). Package was developed sepcially for task concerning strings and so far I have used one function 'str_sub' which takes only the strings in given order of space (from, to). Coordinate strings in our case were also separated from each other to have the Longitude and Latitude in distinct columns and eventually it's eg. Lon: 16°09'9.8'', Lat: 50°58'0.4''.

## Step 2 - Transform the coordinates from Degrees, Minutes and Seconds (DMS) to Decimals (DEC)

Still our strings represent the DMS format and  have the spatial data format in R (SpatialPoints), we have to recalculate it to Decimal Degrees (eg. 16°09'9.8'' --> 16.15272). For this task I have forked the Valentin Ștefan repository code (https://gist.github.com/valentinitnelav/ea94fea68227e05c453e13c4f7b7716b). As it fits our needs! Once the transformation is done we can procced to creation of spatial objects.

## Step 3 - Creation of spatial objects

For this task we will use Longitude and Latitude of points in decimal degree format constructed in "Step 2" and the Coordinate Reference System (CRS). The points used in my example were sampled in from Polish croplands, though we have to pick the Polish coordinate system to project them on the map (CS92 with EPSG:2180 http://spatialreference.org/ref/epsg/etrs89-poland-cs92/). The function 'CoordToShapefile' in R file provided in repository shows how to construct shapefile step by step with use of 'sp' and 'raster' pakage.   
