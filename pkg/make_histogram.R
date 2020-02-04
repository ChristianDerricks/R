make_histogram <- function(y, ylimmin, ylimmax) {
  h <- hist(y, plot = FALSE)

  xfit <- seq(min(y), max(y), length.out = N)
  yfit <- dnorm(xfit, mean = mean(y), sd = sd(y))
  yfit <- yfit * diff(h$mids[1:2]) * length(y)

  plot(NULL, 
      xlim=c(0,ceiling(1.2*max(h$counts)/10)*10), 
      ylim=c(ylimmin,ylimmax),
      bty="o", xaxt="n", xaxs="i", yaxt="n", yaxs="i",xlab="",ylab="",
      )

  rect(xleft   = 0, 
       ybottom = h$mids-diff(h$mids[1:2])/2, 
       xright  = h$counts, 
       ytop    = h$mids+diff(h$mids[1:2])/2,
       col     = "gray"
  )
  #points(yfit,xfit)
  lines(yfit, xfit)
}
