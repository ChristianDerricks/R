# Demonstrate standard error with 95% confidence intervall for the mean.
# Make N normally distributed random numbers (basic population)
# and randomly select a sample with size n. Calculate the standard error 
# and show the 95 % confidence intervall.

source('pkg/initalize.R', local = TRUE)

# Used to export the plot to tikz
make_tikz = FALSE
if (make_tikz) tikzRexport('StandardErrorDemonstration.tex')

# Make some normally distributed random numbers with fixed seed
N = 100
set.seed(1)

x = seq(1, N, by = 1)
y = rnorm(N, mean = 10, sd = 2)

# plot histogram
h    = hist(y, plot = FALSE)
xfit = seq(min(y), max(y), length.out = N)
yfit = dnorm(xfit, mean = mean(y), sd = sd(y))
yfit = yfit * diff(h$mids[1:2]) * length(y)

# Randomly select n samples from y
n = 30
xsel = sample(xfit, n)
ysel = match(xsel, xfit)

# Show the original population N as open points and
# the selected samples as filled points
plot(xfit, yfit, type = 'p', xlab = 'x-values', ylab = 'y-values')
points(xsel, yfit[ysel], pch = 16)

# Calculate the 95% confidence range
alpha = 0.05
Z = abs(round(qnorm(alpha/2), digits = 2))
E = Z*sd(xsel)/sqrt(n)

# Draw lines for both mean values and 95% confidence.
abline(v = mean(xsel)-E, lty = 2)
abline(v = mean(xsel)+E, lty = 2)
abline(v = mean(xsel), lwd = 2, col = cb_orange)
abline(v = mean(y), lwd = 2, col = cb_bluishgreen)

# Add some text
txpos = 7.75
text(txpos-1, 21, 'N: ', pos = 2, col = cb_bluishgreen)
text(txpos-1, 20, 'mean: ', pos = 2, col = cb_bluishgreen)
text(txpos-1, 19, 'sd: ', pos = 2, col = cb_bluishgreen)
text(txpos, 21, paste(N), pos = 2, col = cb_bluishgreen)
text(txpos, 20, sprintf("%.2f", mean(y)), pos = 2, col = cb_bluishgreen)
text(txpos, 19, sprintf("%.2f", sd(y)), pos = 2, col = cb_bluishgreen)

txpos = 15
text(txpos-1, 21, 'n: ', pos = 2, col = cb_orange)
text(txpos-1, 20, 'mean: ', pos = 2, col = cb_orange)
text(txpos-1, 19, 'sd: ', pos = 2, col = cb_orange)
text(txpos, 21, paste(n), pos = 2, col = cb_orange)
text(txpos, 20, sprintf("%.2f", mean(xsel)), pos = 2, col = cb_orange)
text(txpos, 19, sprintf("%.2f", sd(xsel)), pos = 2, col = cb_orange)

mtext('95%', side = 3, at = mean(xsel), line = 1)
arrows(mean(xsel)-E, 24, mean(xsel)+E, 24, code = 3, xpd = TRUE, angle = 10, length = 0.15)

if (make_tikz) dev.off()
