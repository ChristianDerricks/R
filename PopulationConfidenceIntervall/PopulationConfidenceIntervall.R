# Demonstration of confidence and standard deviation 
# intervall for two normally distributed populations.

source('pkg/initalize.R', local = TRUE)

# Export figures with tikz.
make_tikz = FALSE
if (make_tikz) tikzRexport('PopulationConfidenceIntervall.tex')

# Make some normally distributed random numbers with fixed seed
N = 50
set.seed(1)

y1 = rnorm(N, mean = 20, sd = 8)
y2 = rnorm(N, mean = 8, sd = 4)

alpha = 0.05

# Z tables commenly use two digits
#Z = abs(round(qnorm(alpha/2), digits = 2))

# Confidence intervall could be taken from t.test
# NOTE: The values are slightly different.
# htest1 = t.test(y1, conf.level = 1 - alpha)
# htest1$conf.int
# as.numeric(htest1$conf.int[1])
# as.numeric(htest1$conf.int[2])

Z = abs(qnorm(alpha/2))
E1 = Z*sd(y1)/sqrt(N)
E2 = Z*sd(y2)/sqrt(N)

plot(rep(0.9, N), y1, xlim = c(0,3), ylim = c(-2,35), pch = 20, xlab = 'x-values', ylab = 'y-values')
points(rep(2.1, N), y2, pch = 20)

abline(h = mean(y1)-sd(y1), lty = 2, lwd = 0.25)
abline(h = mean(y1)+sd(y1), lty = 2, lwd = 0.25)
abline(h = mean(y2)-sd(y2), lty = 2, lwd = 0.25)
abline(h = mean(y2)+sd(y2), lty = 2, lwd = 0.25)

arrows(1, mean(y1)-sd(y1), 1, mean(y1)+sd(y1), length=0.05, angle=90, code=3, col = cb_bluishgreen)
arrows(2, mean(y2)-sd(y2), 2, mean(y2)+sd(y2), length=0.05, angle=90, code=3, col = cb_bluishgreen)

arrows(1, mean(y1)-E1, 1, mean(y1)+E1, length=0.05, angle=90, code=3, col = cb_vermillion)
arrows(2, mean(y2)-E2, 2, mean(y2)+E2, length=0.05, angle=90, code=3, col = cb_vermillion)

points(1, mean(y1), pch = 20)
points(2, mean(y2), pch = 20)

if (make_tikz) dev.off()
