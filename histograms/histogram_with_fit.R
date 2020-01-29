if(!is.null(dev.list())) dev.off()
graphics.off()

# delete every variable
remove(list = ls())

#library(tikzDevice)
# manually paste the following two lines in the header of the tex file
# %!TEX TS-program = lualatex
# %!TeX encoding = utf8
#tikz_path = '/R/Histogramme/tikz/'
#dir.create(file.path(tikz_path), showWarnings = FALSE)

#tikz_filename = 'histogram_with_fit.tex'
#tizeTEX_path_and_filename = paste(tikz_path, tikz_filename)
#tikz(tizeTEX_path_and_filename, standAlone = TRUE, sanitize = TRUE)

N = 1000
x <- seq(1,N,1)

set.seed(5)
y <- rnorm(N, mean=10, sd=1)

h <- hist(y, plot = FALSE)

plot(NULL, xlim=c(5,15), ylim=c(0,ceiling(1.2*max(h$counts)/10)*10), bty="o",
     xaxs="i", yaxs="i", xlab="x-value", ylab="y-value", main = "histogram with fit")

rect(xleft   = h$mids-diff(h$mids[1:2])/2, 
     ybottom = 0, 
     xright  = h$mids+diff(h$mids[1:2])/2, 
     ytop    = h$counts,
     col     = "gray"
     )

xfit <- seq(min(y), max(y), length.out = N)
yfit <- dnorm(xfit, mean = mean(y), sd = sd(y))
yfit <- yfit * diff(h$mids[1:2]) * length(y)

lines(xfit, yfit)

#dev.off()
