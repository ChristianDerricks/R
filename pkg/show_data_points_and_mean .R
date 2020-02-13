# This function is designed to show data points and mean values for
# data that is usually plotted in boxplots.
#
# Data and groups can have one of two structures:
#
# data group
#  y1    1
#  y2    1
#  y3    1
#  y4    2
#  y5    2
#  y6    2
#  
# or
# 
#   data   group
# y11 y21  1  2
# y12 y22  1  2
# y13 y23  1  2
# 
# offset is used to shift data vertically

show_data_points_and_mean <- function(data, groups, horizontalTF, offset) {

  if (isTRUE(horizontalTF)) {
    points(groups+offset~data, pch = 20, cex = 1, col = cb_darkgrey)
  } else {
    points(groups+offset,data, pch = 20, cex = 1, col = cb_darkgrey)
  }

  grouplength = length(unique(groups))
  N = length(data)/grouplength

  if (identical(NULL, dim(groups)))
  {
    if (isTRUE(horizontalTF)) {
      print('1111')
      for (inx in 1:grouplength) {
        points(mean(data[(1+(inx-1)*N):(inx*N)]), inx+offset, pch = 18, cex = 1, col = cb_yellow)
      }
    } else {
      print('2222')
      for (inx in 1:grouplength) {
        points(inx+offset, mean(data[(1+(inx-1)*N):(inx*N)]), pch = 18, cex = 1, col = cb_yellow)
      }
    }
    
  } else {
    if (isTRUE(horizontalTF)) {
      print('3333')
      for (inx in 1:grouplength) {
        points(mean(data[1:N,inx]), inx+offset, pch = 18, cex = 1, col = cb_yellow)
      }
    } else {
      print('4444')
      for (inx in 1:grouplength) {
        points(inx+offset, mean(data[1:N,inx]), pch = 18, cex = 1, col = cb_yellow)
      }
    }
  }
}
