mark_outliers <- function(data, groups) {

  bp = boxplot(data~groups, plot=FALSE)

  # Calculate the the difference between the lower (bp$stats[2]) and 
  # upper hinge (bp$stats[2]) to determine the IQR. Doing that for every 
  # outlier (through bp$group) is an elegant method to avoid using a loop.
  # Note that group here is a return value of boxplot that contains the 
  # corresponding group of all outliers.
  df = cbind(bp$stats[2,bp$group], bp$stats[4,bp$group])
  IQR <- apply(df, 1, function(x) diff(range(x)))

  # To differently mark the outliers we just need to know which of them
  # are beyond 3 IQR, the others are obviously within 1.5 and 3 IQR.
  #bp$out > abs(bp$stats[4,bp$group])+3*IQR | abs(bp$out) > abs(bp$stats[2,bp$group])+3*IQR
  extreme <- bp$out > abs(bp$stats[4,bp$group])+3*IQR | abs(bp$out) > abs(bp$stats[2,bp$group])+3*IQR

  # using blue circles for mild outliers and a red cross for extreme outliers
  points(bp$out, bp$group, 
         pch=ifelse(extreme, 3, 1), 
         col=ifelse(extreme, rgb(213,94,0, max=255), rgb(0,114,178, max=255)), 
         cex=1.05
  )

}
