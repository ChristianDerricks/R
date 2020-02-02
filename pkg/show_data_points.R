show_data_points <- function(data, groups, offset) {

  N = length(data)/length(unique(groups))
  points(groups+offset~data, pch = 20, cex = 1, col = cb_darkgrey)

  for (inx in 0:length(unique(groups))) {
    points(mean(data[1:N,inx]), inx+offset, pch = 18, cex = 1, col = cb_yellow)
  }
}
