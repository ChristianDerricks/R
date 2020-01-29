if(!is.null(dev.list())) dev.off()
graphics.off()

# delete every variable
remove(list = ls())

#library(tikzDevice)
# manually paste the following two lines in the header of the tex file
# %!TEX TS-program = lualatex
# %!TeX encoding = utf8
#tikz_path = '/home/christian/Dokumente/Programme/R/Histogramme/tikz/'
#dir.create(file.path(tikz_path), showWarnings = FALSE)

#tikz_filename = 'histogram_with_fit_rotated.tex'
#tizeTEX_path_and_filename = paste(tikz_path, tikz_filename)
#tikz(tizeTEX_path_and_filename, standAlone = TRUE, sanitize = TRUE)

N = 1000
x <- seq(1,N,1)

set.seed(5)
y <- rnorm(N, mean=10, sd=1) 

h <- hist(y, plot = FALSE)

plot(NULL, ylim=c(5,15), xlim=c(0,ceiling(1.2*max(h$counts)/10)*10), bty="o",
     xaxt="n", xaxs="i", yaxt="n", yaxs="i", xlab="", ylab="")

rect(xleft   = 0, 
     ybottom = h$mids-diff(h$mids[1:2])/2, 
     xright  = h$counts, 
     ytop    = h$mids+diff(h$mids[1:2])/2,
     col     = "gray"
     )

xfit <- seq(min(y), max(y), length.out = N)
yfit <- dnorm(xfit, mean = mean(y), sd = sd(y))
yfit <- yfit * diff(h$mids[1:2]) * length(y)

lines(yfit, xfit)

#dev.off()
