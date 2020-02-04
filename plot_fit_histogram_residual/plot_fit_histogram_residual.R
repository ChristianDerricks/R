source('pkg/initalize.R', local = TRUE)
source('pkg/make_histogram.R', local = TRUE)

make_tikz = FALSE
if (make_tikz) tikzRexport('control_chart_with_histogram.tex')

# number N of random numbers
N = 100
set.seed(1)

x = seq(1, N, by = 1)
xerr = rnorm(N, mean = 10, sd = 2)
y = 7.3 * x + 8 + 30 * rnorm(N, mean = 10, sd = 2)

m1 <- lm(y~x)
intercept = as.numeric(coefficients(m1))[1]
slope = as.numeric(coefficients(m1))[2]

#fig=c(x1, x2, y1, y2)
#mar=c(bottom, left, top, right)

ylimmin =  100
ylimmax = 1300

# upper left
par(fig=c(0,0.68,0.52,1))
par(mar=c(0,4,2,0))
plot(x,y, #ylim = c(ylimmin,ylimmax),
     bty="o", xaxt="n", xlab="", ylab="")
lines(x, intercept + x*slope, lwd = 2, col = cb_vermillion)
mtext('y-values', side = 2, line = 3)

# upper right
par(fig=c(0.72,1,0.52,1), new=TRUE)
par(mar=c(0,0,2,3))
make_histogram(y-slope*x, 100, 500) # using the slope to normalize the data
axis(3)
axis(4)
mtext('counts',    side = 3, line = 2)
mtext('frequency', side = 4, line = 2)

# residual plots with different y limit
ylimmin = -200
ylimmax =  200

# lower left
par(fig=c(0,0.68,0,0.48), new=TRUE)
par(mar=c(4,4,0,0))
plot(m1$residuals, ylim = c(ylimmin,ylimmax), xlab = '', ylab = '')
mtext('x-values',   side = 1, line = 2)
mtext('residuals',  side = 2, line = 3)

# lower right
par(fig=c(0.72,1,0,0.48), new = TRUE)
par(mar=c(4,0,0,3))
make_histogram(m1$residuals, ylimmin, ylimmax)
axis(1)
axis(4)
mtext('counts',    side = 1, line = 2)
mtext('frequency', side = 4, line = 2)

if (make_tikz) dev.off()
