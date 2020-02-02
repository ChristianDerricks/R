source('pkg/initalize.R', local = TRUE)

make_tikz = TRUE
if (make_tikz) tikzRexport('histogram_with_fit_rotated.tex')

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

if (make_tikz) dev.off()
