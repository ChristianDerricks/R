# This file is used to initalize a few custom packages and do some basic stuff
# so that it must not be included in every program making maintance easier.

# Delete all variables from the global enviroment, remove all plots and
# prevent error messages displayed if there are no plots to clear.
remove(list = ls())
if(!is.null(dev.list())) dev.off()
graphics.off()

# Load a custom colorlist with eight colors.
source('pkg/colorlist.R', local = TRUE)

# A small package to check if RStudio is used
source('pkg/isRStudio.R', local = TRUE)

# Check if RStudio is used, otherwise dont't load tikz_export.
if (is.RStudio()) {
    # load tikz handler
    source('pkg/tikz_export.R', local = TRUE)
  } else {
    message('tikz_export works only with RStudio due to path and basename requierments')
  }
