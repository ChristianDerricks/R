source('pkg/initalize.R', local = TRUE)
source('pkg/custom_histogram.R', local = TRUE)

make_tikz = FALSE
if (make_tikz) tikzRexport('histogram_with_fit.tex')

N = 1000
x <- seq(1,N,1)

set.seed(5)
y <- rnorm(N, mean=10, sd=1)

par(mar=c(3,3,1,1))
custom_histogram(y, 25, 5, 15, TRUE, FALSE)

axis(1)
mtext('x-values', side = 1, line = 2)

axis(2)
mtext('y-values', side = 2, line = 2)

if (make_tikz) dev.off()
