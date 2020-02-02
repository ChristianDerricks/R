# An example in R to demonstrate Nelson 8 rules for out-of-control 
# non random runs in process control charts 
#
# Lloyd S. Nelson, 
# The Shewhart Control Chart—Tests for Special Causes. 
# Journal of Quality Technology 16
# no. 4 (October 1984), pp. 238-239
# https://doi.org/10.1080/00224065.1984.11978921

if(!is.null(dev.list())) dev.off()
graphics.off()

# delete every variable
remove(list = ls())

library(tikzDevice)
library(Rspc)

# This is a list of eight colors that are distinguishable for people with 
# every type of color vision deficiency (often misleadingly called colorblindness).
# see https://jfly.iam.u-tokyo.ac.jp/color/ for more information.
cb_darkgrey      = rgb( 50,  50,  50, max=255)
cb_blue          = rgb(  0, 114, 178, max=255)
cb_orange        = rgb(230, 159,   0, max=255)
cb_bluishgreen   = rgb(  0, 158, 115, max=255)
cb_vermillion    = rgb(213,  94,   0, max=255)
cb_skyblue       = rgb( 86, 180, 233, max=255)
cb_reddishpurple = rgb(204, 121, 167, max=255)
cb_yellow        = rgb(240, 228,  66, max=255)


# manually paste the following two lines in the header of the tex file for full utf8 support
# %!TEX TS-program = lualatex
# %!TeX encoding = utf8
tikz_path = '/home/christian/Dokumente/Programme/R/Prozessregelkarten/tikz/'
dir.create(file.path(tikz_path), showWarnings = FALSE)

tikz_filename = 'control_chart_8_Nelson_rules.tex'
tizeTEX_path_and_filename = paste(tikz_path, tikz_filename)
tikz(tizeTEX_path_and_filename, standAlone = TRUE, sanitize = TRUE)

N = 80
x <- seq(1,N,1)
set.seed(5)
y <- rnorm(N, mean=10, sd=1) 

y[1] = 10; y[2] = 10; y[3] = 10; y[4] = 10;

# Rule 1: One point beyond the control limits (3 standard deviations)
y[5] = 22; y[6] = 1;

# Rule 2: Nine points in a row are on one side of the central line
y[7] = 12; y[8] = 12; y[9] = 12; y[10] = 13; y[11] = 14; y[12] = 12;
y[13] = 13; y[14] = 12.5; y[15] = 13; y[16] = 12; 

# Rule 3: Six points in a row steadily increasing or decreasing
y[17] = 11; y[18] = 10.5; y[19] = 10; y[20] = 9; y[21] = 8; y[22] = 7

# Rule 4: Fourteen or more points in a row alternate in direction, increasing then decreasing
y[23] = 12; y[24] = 8; y[25] = 12; y[26] = 8; y[27] = 12; y[28] = 8; y[29] = 12
y[30] = 8; y[31] = 12; y[32] = 8; y[33] = 12; y[34] = 8; y[35] = 12; y[36] = 8

# Rule 5: Two out of three consecutive points beyond the 
# 2*sigma limits on same side of center line
y[37] = 12; y[38] = 20; y[39] = 19; y[40] = 13; y[41] = 12; y[42] = 16; y[43] = 11;
y[44] = 11; y[45] = 12; y[46] = 13; y[47] = 10; y[48] = 11; y[49] = 12; y[50] = 11;

# Rule 6: Four or five out of five points in a row are more than 
# 1 standard deviation from the mean in the same direction.
y[51] = 17; y[52] = 16; y[53] = 17; y[54] = 16; y[55] = 17;

# Rule 7: Fifteen points in a row are all within 1 standard deviation 
# of the mean on either side of the mean.
y[56] = 12; y[57] = 10; y[58] = 12; y[59] = 10; y[60] = 12; y[61] = 10; y[62] = 12
y[63] = 10; y[64] = 12; y[65] = 10; y[66] = 12; y[67] = 12; y[68] = 12; y[69] = 10
y[70] = 10; y[71] = 10; 

# Rule 8: Eight points in a row outside 1 standard deviation of the mean in both directions.
y[72] = 10; y[73] = 6; y[74] = 16; y[75] = 16; y[76] = 4; 
y[77] = 5; y[78] = 16; y[79] = 6; y[80] = 16;

par(mfrow=c(3,3))
par(mar=c(2,2,2,2))
qcclimits = CalculateLimits(y, type = 'i')
zoneborders = CalculateZoneBorders(qcclimits, controlLimitDistance = 3)

sigmalines <- function (y, N) {
        return (c(abline(mean(y),0,         col = 'black',  lty = 2),
                  abline(mean(y)+1*sd(y),0, col = 'gray50', lty = 3),
                  abline(mean(y)-1*sd(y),0, col = 'gray50', lty = 3),
                  abline(mean(y)+2*sd(y),0, col = 'gray50', lty = 3),
                  abline(mean(y)-2*sd(y),0, col = 'gray50', lty = 3),
                  abline(mean(y)+3*sd(y),0, col = 'gray50', lty = 3),
                  abline(mean(y)-3*sd(y),0, col = 'gray50', lty = 3))
        )
}

# Rule 1
plot(x, y, panel.first = sigmalines(y, N),
     pch = 20, cex = 0.6, main = '1+ beyond 3xsd') 
rule1 = Rule1(y, lcl = qcclimits$lcl, ucl = qcclimits$ucl, sides = 1)
points(x[c(rule1) > 0], y[c(rule1) > 0], pch = 0, cex = 1.2, col = cb_vermillion)

# Rule 2
plot(x, y, panel.first = sigmalines(y, N),
     pch = 20, cex = 0.6, main = '9+ on one side of the mean')
rule2 = Rule2(y, cl = qcclimits$cl, npoints = 9)
points(x[c(rule2) > 0], y[c(rule2) > 0], pch = 1, cex = 1.2, col = cb_blue)

# Rule 3
plot(x, y, panel.first = sigmalines(y, N),
     pch = 20, cex = 0.6, main = '6+ increasing or decreasing')
rule3 = Rule3(y, nPoints = 6, convention = 1, equalBreaksSeries = 1)
points(x[c(rule3) > 0], y[c(rule3) > 0], pch = 2, cex = 1.2, col = cb_bluishgreen)

# Rule 4
plot(x, y, panel.first = sigmalines(y, N),
     pch = 20, cex = 0.6, main = '14+ alternating in direction')
rule4 = Rule4(y, nPoints = 14, convention = 1)
points(x[c(rule4) > 0], y[c(rule4) > 0], pch = 5, cex = 1.2, col = cb_yellow)

par(mar=c(4,4,4,4))
hist(y, main = 'Histogram', ylab = 'Frequency', xlab = 'value')
box()
par(mar=c(2,2,2,2))

# Rule 5
plot(x, y, panel.first = sigmalines(y, N),
     pch = 20, cex = 0.6, main = '2/3 beyond 2xsd')
rule5 = Rule5(y, zoneB = zoneborders, minNPoints = 2, nPoints = 3)
points(x[c(rule5) > 0], y[c(rule5) > 0], pch = 6, cex = 1.2, col = cb_skyblue)

# Rule 6
plot(x, y, panel.first = sigmalines(y, N),
     pch = 20, cex = 0.6, main = '4/5 (one side) more than 1xsd')
rule6 = Rule6(y, zoneB = zoneborders, minNPoints = 4, nPoints = 5)
points(x[c(rule6) > 0], y[c(rule6) > 0], pch = 0, cex = 1.2, col = cb_reddishpurple)

# Rule 7
plot(x, y, panel.first = sigmalines(y, N),
     pch = 20, cex = 0.6, main = '15+ within ±1xsd')
rule7 = Rule7(y, zoneB = zoneborders, nPoints = 15)
points(x[c(rule7) > 0], y[c(rule7) > 0], pch = 1, cex = 1.2, col = cb_orange)

# Rule 8
plot(x, y, panel.first = sigmalines(y, N),
     pch = 20, cex = 0.6, main = '8+ outisde ±1xsd')
rule8 = Rule8(y, zoneB = zoneborders, nPoints = 8)
points(x[c(rule8) > 0], y[c(rule8) > 0], pch = 2, cex = 1.2, col = 'blue')

dev.off()
