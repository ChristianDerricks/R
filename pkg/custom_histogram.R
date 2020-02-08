# This program is intended to produce a histogram for some unusal cases.
# As an example, one of these cases is a rotated histogram, which can not 
# be achieved with the normal hist function, however, with the return values
# and the rect function.
# In addition, a fit for the distribution is also always drawn.
# Styling should be done outside this function, therefor all plot annotations 
# and ticks are removed. Ticks and labels can be set in the program calling 
# this function with axis and mtext.
# A grid in the background can be used by the variable showgrid.

custom_histogram <- function(y, breakpoints, ylimmin, ylimmax, showgrid, rotate) {

  h <- hist(y, breaks = breakpoints, plot = FALSE)

  # fitting is done here
  xfit <- seq(min(y), max(y), length.out = 10*breakpoints)
  yfit <- dnorm(xfit, mean = mean(y), sd = sd(y))
  yfit <- yfit * diff(h$mids[1:2]) * length(y)

  # Two very similar parts in this if function depending on the value of the
  # rotate (T/F). Plotting of an almost empty diagram and rectangles as bars.
  # Axis limits for the height are calculated automatically.
  if (rotate) {
    plot(NULL, ylim=c(ylimmin,ylimmax), xlim=c(0,ceiling(1.2*max(h$counts)/10)*10),  
         main = '', bty='o',
         xaxt='n', xaxs='i', yaxt='n', yaxs='i', xlab='', ylab='',
         panel.first = {box()
                        if (showgrid) {grid()}}
         )

    rect(xleft   = 0, 
         ybottom = h$mids-diff(h$mids[1:2])/2, 
         xright  = h$counts, 
         ytop    = h$mids+diff(h$mids[1:2])/2,
         col     = 'gray')
    lines(yfit, xfit)
  } else {
    plot(NULL, xlim=c(ylimmin,ylimmax), ylim=c(0,ceiling(1.2*max(h$counts)/10)*10), 
         main = '', bty='o',
         xaxt='n', xaxs='i', yaxt='n', yaxs='i', xlab='', ylab='',
         panel.first = {box()
           if (showgrid) {grid()}}
        )
  
    rect(xleft   = h$mids-diff(h$mids[1:2])/2, 
         ybottom = 0, 
         xright  = h$mids+diff(h$mids[1:2])/2, 
         ytop    = h$counts,
         col     = 'gray')
    lines(xfit, yfit)
    }
}
