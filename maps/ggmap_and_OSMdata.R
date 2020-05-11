# This program draws a city map with the ggmap function, uses osmdata to get geo locations of 
# hospitals, fire- and police-stations and merges their cluster points to single logical groups.
# A symbol of a non cairo svg representative image is then used at each location.

source('pkg/initalize.R', local = TRUE)                 # https://github.com/ChristianDerricks/R/blob/master/pkg/initalize.R
source('pkg/get_osm_object.R', local = TRUE)            # https://github.com/ChristianDerricks/R/blob/master/pkg/get_osm_object.R
source('pkg/render_svg.R', local = TRUE)                # https://github.com/ChristianDerricks/R/blob/master/pkg/render_svg.R
source('pkg/merge_cluster_coordinates.R', local = TRUE) # https://github.com/ChristianDerricks/R/blob/master/pkg/merge_cluster_coordinates.R

library(dplyr)
library(ggmap)
library(ggimage)
library(osmdata)
library(rsvg)
library(tidyr)

city    <- osmdata::getbb('Konstanz')
citymap <- ggmap::get_map(city,
                          source = 'stamen',
                          zoom   = 12,
                          force  = FALSE)

hospital     <- get_osm_object('sf', city, 'amenity', c('hospital', 'clinic'))
fire_station <- get_osm_object('sf', city, 'amenity', c('fire_station'))
police       <- get_osm_object('sf', city, 'amenity', c('police'))

hospital_tbl     <- tidyr::tibble('lon' = sf::st_coordinates(hospital$osm_points)[,1],
                                  'lat' = sf::st_coordinates(hospital$osm_points)[,2])
fire_station_tbl <- tidyr::tibble('lon' = sf::st_coordinates(fire_station$osm_points)[,1],
                                  'lat' = sf::st_coordinates(fire_station$osm_points)[,2])
police_tbl       <- tidyr::tibble('lon' = sf::st_coordinates(police$osm_points)[,1],
                                  'lat' = sf::st_coordinates(police$osm_points)[,2])

# Visualization of clustering
#graphics::plot(sf::st_coordinates(hospital$osm_points),      cex = 0.1, pch = 19, col = cb_darkgrey, xlim = c(6.19,6.36), ylim = c(51.530, 51.650))
#graphics::points(merge_cluster_coordinates(hospital_tbl, 2), cex = 1,   pch = 19, col = cb_orange)

symbol_path = paste(getwd(), '/Maps/ggmap/symbols/', sep ='')

symbol_file_name <- 'Hospital-14.svg' # https://wiki.openstreetmap.org/w/images/3/33/Hospital-14.svg
symbol_hospital <- render_svg(symbol_path, symbol_file_name)

symbol_file_name <- 'Fire-station-16.svg' # https://wiki.openstreetmap.org/w/images/5/59/Police-16.svg
symbol_fire_station <- render_svg(symbol_path, symbol_file_name)

symbol_file_name <- 'Police-16.svg' # https://wiki.openstreetmap.org/w/images/b/b7/Fire-station-16.svg
symbol_police <- render_svg(symbol_path, symbol_file_name)

# The numbers of the merge_cluster_coordinates function must be found manually
ggmap(citymap) +
  labs(x = 'Longitude', y = 'Latitude') +
  ggimage::geom_image(data = merge_cluster_coordinates(hospital_tbl, 2),      image = symbol_hospital,     size = 0.02) +
  ggimage::geom_image(data = merge_cluster_coordinates(fire_station_tbl, 10), image = symbol_fire_station, size = 0.02) +
  ggimage::geom_image(data = merge_cluster_coordinates(police_tbl, 5),        image = symbol_police,       size = 0.02)
