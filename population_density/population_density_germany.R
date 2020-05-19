source('pkg/initalize.R', local = TRUE)

library(rgdal)
library(sp)
library(raster)    # Note: The raster package has a lot of functions with the same name as the base package
library(tidyverse)

################## GEO INFORMATION START ##################

# Information about infrastructre in Germany can be found here:
# https://mapcruzin.com/free-germany-arcgis-maps-shapefiles.htm
rivers <- rgdal::readOGR(
  dsn     = '/home/christian/Dokumente/Programme/R/GIS/germany-waterways-shape',
  verbose = FALSE
)

gadmcountry  = 'Germany'
gadmpath     = '/home/christian/Dokumente/Programme/R/GADM'
gadmdownload = FALSE

# Loading spatial polygonal data frames (spdf) with different administraion depth from https://gadm.org
admlvl1 <- raster::getData('GADM', country = gadmcountry, level = 1, download = gadmdownload, path = gadmpath)
admlvl2 <- raster::getData('GADM', country = gadmcountry, level = 2, download = gadmdownload, path = gadmpath)
admlvl3 <- raster::getData('GADM', country = gadmcountry, level = 3, download = gadmdownload, path = gadmpath)
admlvl4 <- raster::getData('GADM', country = gadmcountry, level = 4, download = gadmdownload, path = gadmpath)
#rm(gadmcountry, gadmpath, gadmdownload)

#state  # Bundesland
#county # Kreis

unique(admlvl3$NAME_1) # Helper for state names
#state  <- raster::subset(admlvl1, NAME_1 == 'Bayern')
#county <- raster::subset(admlvl4, NAME_1 == 'Bayern')

state  <- raster::subset(admlvl1)
county <- raster::subset(admlvl4)

# CC_i might contain na values that are removed here from the spdf named county.
# All corresponding rows will then deleted.
county <- raster::subset(county,  CC_4 != is.na(CC_4))

# Test if the line above works as intended. The result must always be zero and print TRUE.
length(county$NAME_4) - length(county$CC_4) == 0

################## GEO INFORMATION END ##################


################## READ DATA FILE START ##################

main_R_path = '/home/christian/Dokumente/Programme/R/'
inputdata <- base::list()

# Statistical information about Germany can be found here at:
# http://www.statistikportal.de/de/datenbanken#genesis-online-bund
path_to_file = paste(main_R_path, 'GENESIS/', sep = '')

# This files contains the number of people living in each independet unique administration unit
file_name  = '12111-01-01-5-B.csv'
peopledata <- readr::read_delim(file      = paste(path_to_file, file_name, sep = ''),
                                locale    = readr::locale('en', decimal_mark = ','),
                                col_names = c('CIN', paste('V', 2:11, sep = '')),
                                col_types = 'cciiiiiiiii', # c = character, i = integer
                                delim     = ';',
                                trim_ws   = TRUE,
                                skip      = 10)
inputdata[[1]] <- head(peopledata, -3) # remove some of the last lines

# This files contains the area in km² of each independet unique administration unit
# NOTE: The raster package has a function raster::area that can actually calculate 
# the area, however, the official number is used here.
file_name = '11111-01-01-5-B.csv'
areadata  <- readr::read_delim(file      = paste(path_to_file, file_name, sep = ''),
                               locale    = readr::locale('en', decimal_mark = ','),
                               col_names = c('CIN', paste('V', 2:3, sep = '')),
                               col_types = 'ccn', # c = character, n = number
                               delim     = ';',
                               trim_ws   = TRUE,
                               skip      = 7)
inputdata[[2]] <- head(areadata, -4)

# Names of cities from this file to print with the final map.
path_to_file = paste(main_R_path, 'Maps/gadm_population_density/', sep = '')
file_name    = 'large_cities.csv'
state_and_city <- readr::read_delim(file  = paste(path_to_file, file_name, sep = ''),
                                locale    = readr::locale('en', decimal_mark = ','),
                                col_names = c('state', 'city'),
                                col_type  = 'cc',
                                delim     = ',',
                                trim_ws   = TRUE,
                                skip      = 0)

# A simple solution without elegance to subset a spdf against vectors
cities <- raster::subset(admlvl4, NAME_1 == state_and_city$state[1] & NAME_3 == state_and_city$city[1])
for (idx in 2:dim(state_and_city)[1]) {
  cities = base::rbind(cities,
                       raster::subset(admlvl4, NAME_1 == state_and_city$state[idx] & NAME_3 == state_and_city$city[idx]))
}

#rm(path_to_file, file_name, peopledata, areadata)

################## READ DATA FILE END ##################


################## MATCHING START ##################

# Matching of geo spatial information with corresponing data is done by utilizing a unique 
# Community Identification Number (CIN). CINs are a sequence of official administration 
# subdivision identifier numbers for each politically independent unit in some countries 
# (like Germany). This circumvents all sorts of problems with local names (latin or non latin),
# encoding and spelling.
# Note: Geospatial data from gadm sometimes offers an alternative called HASC identifers. 
# designed by Statoids. Referenced data must also contain this information.
# No matter what reference is used, matching must always be done with extreme care.
# Different databases (like gadm, GENESIS) might be outdated or miss CINs for some reasons 
# (like two areas were merged or one is split in two new).
#
# The definition for CINs in Germany can be found at: 
# https://en.wikipedia.org/wiki/Community_Identification_Number#Germany
# Example for the municipality Neuhardenberg:
# Full area code for:          120645410340
# Level 4 gadm area code:      120645410340
# GENESIS data base area code: 12064    340
# The missing part is not a problem here because it stands for a local 
# administration office (Amt) of several subregions (municipalities or cities).
# Characters 6 to 9 must be removed from gadm CC_i for matching.

# All sets of CINs are saved in a list
set <- base::list()

set[[1]] <- base::as.character(county$CC_4)
set[[1]] <- tidyr::tibble('CIN' = paste(substring(set[[1]], 1, 5), substring(set[[1]], 10, 12), sep=''))

set[[2]] <- dplyr::select(inputdata[[1]], 'CIN')
set[[3]] <- dplyr::select(inputdata[[2]], 'CIN')

# Check if all CINs after string manipulation really are unique.
# Result must be: TRUE TRUE
for (idx in 1:length(set)) {
  print(base::dim(base::unique(set[[idx]])) == base::dim(set[[idx]]))
}

# Keep only those CINs from data sets that have a match with gadm data.
# It could also be nice to know which CINs do not have a match and to add them,
# maybe in someway highlighted, to the plot.
matching_subsets    = dplyr::as.tbl(set[[1]])
notmatching_subsets = dplyr::as.tbl(set[[1]])

for (idx in 2:length(set)) {
  matching_subsets    = dplyr::semi_join(matching_subsets,    set[[idx]])
  notmatching_subsets = dplyr::anti_join(notmatching_subsets, set[[idx]])
}

# Check if all CINs after matching really are unique.
# Result must be: TRUE TRUE
base::dim(base::unique(matching_subsets)) == base::dim(matching_subsets)

# Seperate the entries in the spatial polygonal data frame that have a match with
# the reference data from those that have not. Make both sets available for plotting.
index     = which(set[[1]]$CIN %in% notmatching_subsets$CIN)
removeCIN = tidyr::tibble('CIN' = county$CC_4)$CIN[index]
countybad = raster::subset(county, county$CC_4 %in% removeCIN)

index   = which(set[[1]]$CIN %in% matching_subsets$CIN)
keepCIN = tidyr::tibble('CIN' = county$CC_4)$CIN[index]
county  = raster::subset(county, county$CC_4 %in% keepCIN)

#rm(removeCIN, keepCIN, index)

# Ordering data that is used for coloring each area is needed, is easier (and maybe faster)
# performed on a table than a spatial polygonal data frame.
# As kind of a consistency check, first randomly sort the matchting CINs. If the lines below work
# as intended it should in the end create a reasonable plot, otherwise chaos.
matching_subsets = dplyr::sample_n(matching_subsets, max(base::dim(matching_subsets)))

# For all later calculations matching_df is a list that contains several tibbles
# with matching subsets of the input data.
matching_df <- base::list()
for (idx in 1:(length(set)-1)) {
  matching_df[[idx]] = base::subset(inputdata[[idx]], CIN %in% matching_subsets$CIN)
  dataorder          = base::order(base::match(matching_df[[idx]]$CIN, set[[1]]$CIN))
  matching_df[[idx]] = matching_df[[idx]][dataorder,]
}
#rm(dataorder, idx, inputdata, set, matching_subsets, notmatching_subsets)

################## MATCHING END ##################

################## COLOR FILLING START ##################

# Missing area values in the data set can be calculated by raster::area(). First these
# must be found and then match to the original data set.
set[[1]] <- base::as.character(county$CC_4)
set[[1]] <- tidyr::tibble('CIN'     = paste(substring(set[[1]], 1, 5), substring(set[[1]], 10, 12), sep=''),
                          'FullCIN' = county$CC_4)

index <- which(is.na(matching_df[[2]]$V3))
MissingAreaCINs <- tidyr::tibble('CIN'= set[[1]]$FullCIN[index])

missing_area <- list()
for (idx in 1:length(MissingAreaCINs$CIN) ) {
  missing_area[[idx]] <- raster::subset(admlvl4, CC_4 == MissingAreaCINs$CIN[idx]) %>% raster::area()/10^6
}
matching_df[[2]]$V3[index] = as.numeric(missing_area)


# After matching and sorting, data from desired columns is taken
# to calculate filling color values.
# colval = number of people per CIN area / CIN area in km²
colval = matching_df[[1]]$V3/matching_df[[2]]$V3

# Take care of NA values.
colval[is.na(colval)] = -1

# Replace certain ranges with predefined values.
colval[colval >    0 & colval <=   50] = 1
colval[colval >   50 & colval <=  100] = 2
colval[colval >  100 & colval <=  250] = 3
colval[colval >  250 & colval <=  500] = 4
colval[colval >  500 & colval <= 1000] = 5
colval[colval > 1000 & colval <= 2000] = 6
colval[colval > 2000                 ] = 7

# Apply colors to the values
colval = replace(colval, colval == -1, cb_orange) # for NA
colval = replace(colval, colval ==  1, '#e5f5e0')
colval = replace(colval, colval ==  2, '#c7e9c0')
colval = replace(colval, colval ==  3, '#a1d99b')
colval = replace(colval, colval ==  4, '#74c476')
colval = replace(colval, colval ==  5, '#41ab5d')
colval = replace(colval, colval ==  6, '#238b45')
colval = replace(colval, colval ==  7, '#006d2c')
#colval = replace(colval, colval ==  8, '#00441b')

################## COLOR FILLING END ##################

################## MAPPING START ##################

raster::plot(county,    col=colval,    border=NA,          lwd=0.005)
raster::plot(countybad, col=cb_yellow, border=NA,          lwd=0.005, add = TRUE)
raster::plot(rivers,    col=cb_blue,                       lwd=1.00,  add = TRUE)
raster::plot(state,                    border=cb_darkgrey, lwd=1.25,  add = TRUE)
# raster::text is for some reason silently ignored (fallback without warning?) 
# and graphics::text is used instead. As a reminder to that problem the call is 
# now done explcitly with graphics.
graphics::text(coordinates(cities), labels = cities$NAME_3, cex = 0.5, col = cb_darkgrey)

#raster::plot(missing_area_spdf, col=cb_darkgrey, border=grey(0.6), lwd=0.50, add = TRUE)

legend(5.5, 55.5, title = 'population density in km²',
        legend = c('0 - 50', '50 - 100', '100 - 250',
                   '250 - 500', '500 - 1000', '1000 - 2000', '> 2000', 'no data', 'not matchting'),
        fill   = c('#e5f5e0', '#c7e9c0', '#a1d99b', '#74c476', '#41ab5d', '#238b45', '#006d2c', cb_orange, cb_yellow),
        cex = 0.3, bty = 'n'
)

################## MAPPING END ##################
