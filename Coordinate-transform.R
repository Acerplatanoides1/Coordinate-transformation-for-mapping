#String coordinate transformation and visualization in R

#Step 1 - Separate coorinates from string

library(stringr)
library(raster)
library(sp)

filename = "coordinatexy.txt"
names = c("Profile", "Coord")
data = read.table(filename,sep = "\t", stringsAsFactors = FALSE, col.names = nazwy,header = TRUE)
path = "C:/Users/...your path"
str(data)

split_coord_XY <- function(Coord, path) {
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

#Step 2 - Change to Degree Minute Second na Decimals

dg2dec <- function(varb, Dg=NA, Min=NA, Sec=NA, SW.Hemisphere="S|W") {
  DMS <- sapply(strsplit(varb, paste0('[', Dg, Min, Sec, ']')), as.numeric)
  decdg <- abs(DMS[1, ]) + DMS[2, ]/60 + ifelse(dim(DMS)[1] > 2  & !is.na(Sec), DMS[3, ]/3600, 0)
  SW <- grepl(pattern = SW.Hemisphere, x = varb, ignore.case = TRUE)
  return(ifelse(SW, -1, 1) * decdg)
}

coord_lon = data.frame(Lon = dg2dec(varb=coord$Lon, Dg="°", Min="'", Sec = "''N|E"))
coord_lat = data.frame(Lat = dg2dec(varb=coord$Lat, Dg="°", Min="'", Sec = "''N|E"))
coord_lon

#Step 3 - Creation of spatial objects

CoordToShapefile <- function(Longitude, Latitude, filename) {
  toShapefile = data.frame(Longitude, Latitude)
  coordinates(toShapefile) = ~Lon+Lat
  proj4string(toShapefile) = CRS("+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs") 
  ## Polish Coordinate Reference System: CS92; EPSG:2180
  transformed = spTransform(toShapefile, CRS("+proj=longlat"))
  raster::shapefile(transformed,filename,overwrite = TRUE)
  return(transformed)
}
g = "C:/Users/...your path.shp"
shapefile = CoordToShapefile(coord_lon,coord_lat,g)
plot(shapefile, main = "Mapped points") 

# Done!
