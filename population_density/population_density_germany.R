source('pkg/initalize.R', local = TRUE)
library(rgdal)
library(sp)
library(raster)
library(dplyr)
library(tidyverse)

################## GEO INFORMATION START ##################

gadmcountry  = 'Germany'
gadmpath     = '/home/christian/Dokumente/Programme/R/GADM'
gadmdownload = FALSE

# Loading spatial polygonal data frames with different administraion depth
admlvl1 <- raster::getData('GADM', country = gadmcountry, level = 1, download = gadmdownload, path = gadmpath)
admlvl2 <- raster::getData('GADM', country = gadmcountry, level = 2, download = gadmdownload, path = gadmpath)
admlvl3 <- raster::getData('GADM', country = gadmcountry, level = 3, download = gadmdownload, path = gadmpath)
admlvl4 <- raster::getData('GADM', country = gadmcountry, level = 4, download = gadmdownload, path = gadmpath)

#state  # Bundesland
#county # Kreis

singlestate = FALSE
unique(admlvl3$NAME_1) # chose one of different possible names
if (singlestate) {
  selected_state = 'Bayern'
  state  <- raster::subset(admlvl2, NAME_1 == selected_state)
  county <- raster::subset(admlvl4, NAME_1 == selected_state)
} else {
  state  <- raster::subset(admlvl1)
  county <- raster::subset(admlvl4)
}

if (singlestate == FALSE) {
cities <- raster::subset(admlvl4,
                           NAME_1 == 'Bayern' & NAME_3 == 'München' |
                           NAME_3 == 'Berlin'  |
                           NAME_3 == 'Stuttgart'  |
                           NAME_3 == 'Bonn'  |
                           NAME_3 == 'Düsseldorf'  |
                           NAME_3 == 'Hamburg'  |
                           NAME_3 == 'Dortmund'  |
                           NAME_3 == 'Leipzig'  |
                           NAME_3 == 'Nürnberg'  |
                           NAME_3 == 'Magdeburg' |
                           NAME_3 == 'Köln' |
                           NAME_3 == 'Erfurt' |
                           NAME_3 == 'Frankfurt am Main' |
                           NAME_3 == 'Saarbrücken' |
                           NAME_3 == 'Hannover' |
                           NAME_3 == 'Schwerin' |
                           NAME_3 == 'Jena' |
                           NAME_3 == 'Essen' |
                           NAME_3 == 'Augsburg' |
                           NAME_3 == 'Würzburg' |
                           NAME_3 == 'Münster' & NAME_1 == 'Nordrhein-Westfalen' |
                           NAME_3 == 'Bielefeld' |
                           NAME_3 == 'Wolfsburg' |
                           NAME_3 == 'Bremen' |
                           NAME_3 == 'Koblenz' |
                           NAME_3 == 'Halle' |
                           NAME_3 == 'Kassel' |
                           NAME_3 == 'Ulm' |
                           NAME_3 == 'Bamberg' |
                           NAME_3 == 'Passau' |
                           NAME_3 == 'Bayreuth' |
                           NAME_3 == 'Würzburg' |
                           NAME_3 == 'Paderborn' |
                           NAME_3 == 'Erlangen' |
                           NAME_3 == 'Kempten (Allgäu)' |
                           NAME_3 == 'Chemnitz' |
                           NAME_3 == 'Ingolstadt' |
                           NAME_3 == 'Aschaffenburg' |
                           NAME_3 == 'Aachen' |
                           NAME_3 == 'Hildesheim' |
                           NAME_3 == 'Trier' |
                           NAME_3 == 'Ludwigshafen am Rhein' |
                           NAME_3 == 'Wiesbaden' |
                           NAME_3 == 'Halle (Saale)' |
                           NAME_3 == 'Karlsruhe' |
                           NAME_3 == 'Heilbronn' |
                           NAME_3 == 'Gießen' |
                           NAME_3 == 'Bitburg' |
                           NAME_3 == 'Marburg' |
                           NAME_3 == 'Darmstadt' |
                           NAME_3 == 'Oldenburg (Oldb)' |
                           NAME_3 == 'Fulda' |
                           NAME_3 == 'Siegen' |
                           NAME_3 == 'Braunschweig' |
                           NAME_3 == 'Cottbus' |
                           NAME_3 == 'Regensburg' |
                           NAME_3 == 'Kaiserslautern' |
                           NAME_3 == 'Rostock' |
                           NAME_3 == 'Freiburg im Breisgau' |
                           NAME_3 == 'Dresden' |
                           NAME_3 == 'Kiel' |
                           NAME_3 == 'Amberg' |
                           NAME_3 == 'Göttingen' |
                           NAME_3 == 'Flensburg' |
                           NAME_3 == 'Lübeck' |
                           NAME_3 == 'Osnabrück' |
                           NAME_3 == 'Neumünster' |
                           NAME_3 == 'Potsdam' |
                           NAME_3 == 'Gera' |
                           NAME_3 == 'Hof' |
                           NAME_3 == 'Mainz' |
                           NAME_3 == 'Leverkusen' |
                           NAME_3 == 'Tübingen' |
                           NAME_3 == 'Pforzheim' |
                           NAME_3 == 'Eisenach' |
                           NAME_3 == 'Landshut' |
                           NAME_3 == 'Schweinfurt' |
                           NAME_3 == 'Zwickau' |
                           NAME_3 == 'Rosenheim' |
                           NAME_3 == 'Minden' |
                           NAME_3 == 'Lüneburg' |
                           NAME_3 == 'Suhl' |
                           NAME_3 == 'Ansbach' |
                           NAME_3 == 'Plauen' |
                           NAME_3 == 'Coburg' |
                           NAME_3 == 'Freiberg' |
                           NAME_3 == 'Deggendorf' |
                           NAME_3 == 'Freising' |
                           NAME_3 == 'Baden-Baden' |
                           NAME_3 == 'Celle' |
                           NAME_3 == 'Bautzen' |
                           NAME_3 == 'Landsberg am Lech' |
                           NAME_3 == 'Wilhelmshaven'
                           )
}
# CC_i might contain na values that are removed here.
# All corresponding rows will then deleted.
county <- raster::subset(county,  CC_4 != is.na(CC_4))
# Test if the line above worked as intended. The value below must always be zero.
length(county$NAME_4) - length(county$CC_4) == 0

################## GEO INFORMATION END ##################


################## READ DATA FILE START ##################

# Data can be found here: http://www.statistikportal.de/de/datenbanken#genesis-online-bund
path_to_file = '/home/christian/Dokumente/Programme/R/GENESIS/'

# This files contains the number of people living in each independet unique administration unit
file_name    = '12111-01-01-5-B.csv'
peopledata <- readr::read_delim(file      = paste(path_to_file, file_name, sep = ""),
                                locale    = readr::locale('en', decimal_mark = ","),
                                col_names = c('CIN', paste('V', 2:11, sep = "")),
                                col_types = 'cciiiiiiiii',
                                delim     = ';',
                                trim_ws   = TRUE,
                                skip      = 10)
peopledata <- head(peopledata, -3) # remove some of the last lines

# This files contains the area (km²) of each independet unique administration unit
# NOTE: raster has a function raster::area that can actually calculate the area, however,
# the official number is used here.
file_name    = '11111-01-01-5-B.csv'
areadata <- readr::read_delim(file      = paste(path_to_file, file_name, sep = ""),
                              locale    = readr::locale('en', decimal_mark = ","),
                              col_names = c('CIN', paste('V', 2:3, sep = "")),
                              col_types = 'ccn',
                              delim     = ';',
                              trim_ws   = TRUE,
                              skip      = 7)
areadata <- head(areadata, -4)

################## READ DATA FILE END ##################


################## MATCHING START ##################

# Matching of geo spatial information with corresponing data is done by utilizing a unique 
# Community Identification Number (CIN). CINs are a sequence of official administration 
# subdivision identifier numbers for each politically independent units in some countries 
# (like Germany). This circumvents all sorts of problems with local names (latin or non latin),
# encoding and spelling.
# Geospatial data from gadm sometimes offers an alternative called HASC identifers designed by Statoids. 
# Referenced data must also contain this information.
# No matter what reference is used, matching must always be done with extreme care.
# Different databases (gadm, GENESIS) might be outdated or miss CINs for some reasons 
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
# Characters 6 to 9 must be removed from gadm CC_i column matching.

# All CINs are saved in list
set <- list()

set[[1]] <- base::as.character(county$CC_4)
set[[1]] <- tibble('CIN' = paste(substring(set[[1]], 1, 5), substring(set[[1]], 10, 12), sep=''))
set1org  <- tibble('CIN' = county$CC_4) # Later needed to identify missing matches

set[[2]] <- dplyr::select(peopledata, CIN)
set[[3]] <- dplyr::select(areadata, CIN)

# Check if all CINs after string manipulation really are unique.
# Result must be: TRUE TRUE
for (idx in 1:length(set)) {
  print(dim(base::unique(set[[idx]])) == dim(set[[idx]]))
}

# Keep only those CINs from data sets that have a match with the gadm data.
# It could also be nice to know which CINs do not have a match and to add them,
# maybe in someway highlighted, to a plot.
total_matching_subset    = as.tbl(set[[1]])
total_notmatching_subset = as.tbl(set[[1]])

for (idx in 2:length(set)) {
  total_matching_subset    = dplyr::semi_join(total_matching_subset,    set[[idx]])
  total_notmatching_subset = dplyr::anti_join(total_notmatching_subset, set[[idx]])
}

# Check if all CINs after matching really are unique.
# Result must be: TRUE TRUE
dim(base::unique(total_matching_subset)) == dim(total_matching_subset)

# Seperate the entries in the spatial polygonal data frame that have a match with
# the reference data from those that have not. 
removeCINindex = which(set[[1]]$CIN %in% total_notmatching_subset$CIN)
removeCIN      = set1org$CIN[removeCINindex]
countybad      = raster::subset(county, county$CC_4 %in% removeCIN)

keepCINindex   = which(set[[1]]$CIN %in% total_matching_subset$CIN)
keepCIN        = set1org$CIN[keepCINindex]
county         = raster::subset(county, county$CC_4 %in% keepCIN)

# Now ordering the data that is used for coloring each area is needed, which is easier
# on a table than a spatial polygonal data frame.
# As kind of a consistency check randomly sort the matchting CIN. If the program works as intended
# it should in the end create a reasonable plot, otherwise chaos.
total_matching_subset_org = total_matching_subset
total_matching_subset = dplyr::sample_n(total_matching_subset, max(dim(total_matching_subset)))

data <- base::list()
data[[1]] <- peopledata
data[[2]] <- areadata

matching_df <- base::list()
for (idx in 1:(length(set)-1)) {
  matching_df[[idx]] = base::subset(data[[idx]], CIN %in% total_matching_subset$CIN)
  dataorder          = base::order(base::match(matching_df[[idx]]$CIN, set[[1]]$CIN))
  matching_df[[idx]] = matching_df[[idx]][dataorder,]
}

# Another consistency test to see if ordering the reference data according
# to the order in the spatial polygonal data frame worked.
# The test result must be TRUE or the map will be filled in the wrong way.
all.equal(paste(substring(county$CC_4, 1, 5), substring(county$CC_4, 10, 12), sep=''), 
          as.character(total_matching_subset_org$CIN))

################## MATCHING END ##################

################## COLOR FILLING START ##################

# After matching and sorting data from desired columns is taken
# to calculate the color values for filling.
# calval = number of people per CIN area / CIN area in km²
colval = matching_df[[1]]$V3/matching_df[[2]]$V3

# Take care of NA values.
colval[is.na(colval)] = -1

# Replace certain ranges with predefined values.
colval[colval >   -1 & colval <=   10] = 1
colval[colval >   10 & colval <=   50] = 2
colval[colval >   50 & colval <=  100] = 3
colval[colval >  100 & colval <=  250] = 4
colval[colval >  250 & colval <=  500] = 5
colval[colval >  500 & colval <= 1000] = 6
colval[colval > 1000 & colval <= 2000] = 7
colval[colval > 2000                 ] = 8

# Apply colors to the values
colval = replace(colval, colval == -1, cb_orange) # for NA
colval = replace(colval, colval ==  1, '#e5f5e0')
colval = replace(colval, colval ==  2, '#c7e9c0')
colval = replace(colval, colval ==  3, '#a1d99b')
colval = replace(colval, colval ==  4, '#74c476')
colval = replace(colval, colval ==  5, '#41ab5d')
colval = replace(colval, colval ==  6, '#238b45')
colval = replace(colval, colval ==  7, '#006d2c')
colval = replace(colval, colval ==  8, '#00441b')

################## COLOR FILLING END ##################

################## PLOTTING START ##################

if (singlestate == FALSE) {
  raster::plot(county,    col=colval,  border=grey(0.6), lwd=0.5)
  raster::plot(state,                  border=grey(0),   lwd=0.5, add = TRUE)
  raster::plot(countybad, col=cb_blue, border=grey(0.6), lwd=0.5, add = TRUE)
} else {
  raster::plot(state,                  border=grey(0),   lwd=0.5)
}

# Information about waterways in Germany can be found here:
# https://mapcruzin.com/free-germany-arcgis-maps-shapefiles.htm
rivers <- readOGR(
  dsn= '/home/christian/Dokumente/Programme/R/GIS/germany-waterways-shape' ,
  layer="waterways",
  verbose=FALSE
)
raster::plot(rivers, col=cb_blue, lwd=0.75, add = TRUE)

if (singlestate == FALSE) {
  raster::text(coordinates(cities), labels = cities$NAME_3, cex = 0.4, col = 'white')
}
# legend(15, 55, title = 'Einwohner pro km²',
#        legend = c('< 10', '10 bis 25', '25 bis 50', '50 bis 100', '100 bis 250',
#                   '250 bis 500', '500 bis 1000', '1000 bis 2000', '> 2000'),
#        fill   = c('#f7fcf5', '#e5f5e0', '#c7e9c0', '#a1d99b', '#74c476', '#41ab5d', '#238b45', '#006d2c', '#00441b'),
#        cex = 0.6, bty = "n"
# )

################## PLOTTING END ##################
