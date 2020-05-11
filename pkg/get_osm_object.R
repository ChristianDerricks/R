# Simplified call and return of osmdata object/feature 
# in sp or sf format using the Overpass query.
#
# sf_or_sp:  'sf' or 'sp'
# osm_city:  'Berlin'
# osm_key:   'amenity'
# osm_value: c('hospital', 'clinic')
# Example: hospital <- get_osm_object('sf', city, 'amenity', c('hospital', 'clinic'))

get_osm_object <- function(sf_or_sp, osm_city, osm_key, osm_value) {
  require(osmdata)
  if (sf_or_sp == 'sf') {
    osmlist <- osm_city                                                   %>%
               osmdata::opq(timeout = 500)                                %>%
               osmdata::add_osm_feature(key = osm_key, value = osm_value) %>%
               osmdata::osmdata_sf()
    
  } else if (sf_or_sp == 'sp') {
    osmlist <- osm_city                                                   %>%
               osmdata::opq(timeout = 500)                                %>%
               osmdata::add_osm_feature(key = osm_key, value = osm_value) %>%
               osmdata::osmdata_sp()
             }
  return(osmlist)
}
