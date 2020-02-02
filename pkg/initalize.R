# prevent error messages displayed if there are no plots to clear
if(!is.null(dev.list())) dev.off()
graphics.off()

# delete every variable
remove(list = ls())

# load colorlist with eight colors
source('pkg/colorlist.R', local = TRUE)

# load tikz handler
source('pkg/tikz_export.R', local = TRUE)
