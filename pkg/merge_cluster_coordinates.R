# This function is used to cluster multiple geo locations to logical groups.
# This post helped: https://stackoverflow.com/questions/26540831/how-to-cluster-points-and-plot
#
# See ggmap_and_OSMdata.R for how to use.

merge_cluster_coordinates <- function(inputdata, k_cutree) {

  require(stats)
  require(tidyr)

  if (dplyr::is.tbl(inputdata) == TRUE) {
    dend <- stats::hclust(stats::dist(inputdata))
    #graphics::plot(dend, hang = -1)
    clustergroups  <- stats::cutree(dend, k = k_cutree) # groups would be a bad variable name because there is a function called groups in dplyr
    coordinate_tbl <- tidyr::tibble('lon' = base::tapply(inputdata[,1]$lon, clustergroups, base::mean),
                                    'lat' = base::tapply(inputdata[,2]$lat, clustergroups, base::mean))
    return(coordinate_tbl)
  } else {
    base::message('Input data must be a tibble')
  }
}
