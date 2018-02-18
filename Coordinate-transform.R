
#
```{r setup}
knitr::opts_knit$set(root.dir = normalizePath("C:/Users/...")) 
```


1. Separate coorinates from string
```{r}

library(sf)
library(dplyr)
library(raster)
filename = "coordinatexy.txt"
nazwy = c("Profile", "Coord")
dane = read.table(filename,sep = "\t", stringsAsFactors = FALSE, col.names = nazwy,header = TRUE)
path = "C:/Users/...your path"
str(data)

split_coord_XY <- function(Coord, path) {
  library(stringr)
  path = path
  for (i in Coord) {
    spli_x = str_sub(Coord, start = 3, end = 18)
    spli_y = str_sub(Coord, start = 19, end = 38)
  }
  splx1 = sub(pattern = "\\N", replacement = "", x = spli_x)
  splx2 = sub(pattern = "\\;", replacement = "", x = splx1)
  splx3 = sub(pattern = "\\:", replacement = "", x = splx2)
  sply1 = sub(pattern = "\\N", replacement = "", x = spli_y)
  sply2 = sub(pattern = "\\:", replacement = "", x = sply1)
  sply3 = sub(pattern = "\\;", replacement = "", x = sply2)
  spli = data.frame(Lon = splx3, Lat = sply3, stringsAsFactors = FALSE)
  spli[,1] = gsub("[[:space:]]", "", x = spli$Lon)
  spli[,2] = gsub("[[:space:]]", "", x = spli$Lat)
  write.csv2(spli, file = path)
  return(spli)
}

coord = split_coord_XY(dane$Coord, path)
coord


```

2.Change to Degree Minute Second na Decimals


```{r}

dg2dec <- function(varb, Dg=NA, Min=NA, Sec=NA, SW.Hemisphere="S|W") {
  DMS <- sapply(strsplit(varb, paste0('[', Dg, Min, Sec, ']')), as.numeric)
  decdg <- abs(DMS[1, ]) + DMS[2, ]/60 + ifelse(dim(DMS)[1] > 2  & !is.na(Sec), DMS[3, ]/3600, 0)
  SW <- grepl(pattern = SW.Hemisphere, x = varb, ignore.case = TRUE)
  return(ifelse(SW, -1, 1) * decdg)
}

coord_lon = data.frame(Lon = dg2dec(varb=coord$Lon, Dg="°", Min="'", Sec = "''N|E"))
coord_lat = data.frame(Lat = dg2dec(varb=coord$Lat, Dg="°", Min="'", Sec = "''N|E"))
coord_lon
```

3. Change coorinates to ESRI Shapefile
```{r}
CoordToShapefile <- function(Longitude, Latitude, filename) {
  library(sf)
  toShapefile = matrix(Longitude, Latitude)
  coordinates(toShapefile) = ~Lon+Lat
  proj4string(toShapefile) = CRS("+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs") ## Polish Coordinate Reference System: CS92; EPSG:2180
  transformed = spTransform(toShapefile, CRS("+proj=longlat"))
  raster::shapefile(transformed,filename,overwrite = TRUE)
  return(transformed)
}
g = "C:/Users/...your path.shp"
shapefile = CoordToShapefile(coord_lon,coord_lat,g)
plot(shapefile,main = "Points where soils samples has been taken") 

```
