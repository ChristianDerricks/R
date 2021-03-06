# An example in R to demonstrate Nelson 8 rules for out-of-control 
# non random runs in process control charts 
#
# Lloyd S. Nelson, 
# The Shewhart Control Chart—Tests for Special Causes. 
# Journal of Quality Technology 16
# no. 4 (October 1984), pp. 238-239
# https://doi.org/10.1080/00224065.1984.11978921

library(Rspc)

source('pkg/initalize.R', local = TRUE)

make_tikz = TRUE
if (make_tikz) tikzRexport('control_chart_with_histogram.tex')


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

h = hist(y, plot = FALSE)

ylimmax = max(h$mids)+2
ylimmin = min(h$mids)-2

par(fig=c(0,0.7,0,1), new=FALSE)
par(mar=c(7,3,2,0))

plot(x, y, 
     panel.first = c (abline(mean(y),0,         col = cb_darkgrey,  lty = 1),
                      abline(mean(y)+1*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)-1*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)+2*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)-2*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)+3*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)-3*sd(y),0, col = 'gray50', lty = 3),
                      
                      abline(14,0, col = cb_blue, lty = 2),
                      abline(6, 0, col = cb_blue, lty = 2)
                      #abline(mean(y)+2.5*sd(y),0, col = 'green', lty = 5),
                      #abline(mean(y)-2.5*sd(y),0, col = 'green', lty = 5)
                      ),
     xlab = "", yaxs="i", ylim = c(ylimmin,ylimmax),
     ylab = "", 
     type = 'b', 
     pch  = 20, 
     cex  = 0.5)

mtext('sample', side=1, line=2)
mtext('property', side=2, line=2)
mtext('control chart with special markings', side=3, line = 0.5)

legend("bottom", title = 'Type of Nelson Rule Violations',
       legend=c("Rule 1", "Rule 5", "Rule 2", "Rule 6", 
                "Rule 3", "Rule 7", "Rule 4", "Rule 8"),
       pch = c(0,6,1,0,2,1,5,2),
       col = c(cb_vermillion,
             cb_skyblue,
             cb_blue,
             cb_reddishpurple,
             cb_bluishgreen,
             cb_orange,
             cb_yellow,
             cb_blue
             ),
       ncol = 4,
       bg = 'gray98',
       cex = 0.6)

qcclimits = CalculateLimits(y, type = 'i')
zoneborders = CalculateZoneBorders(qcclimits, controlLimitDistance = 3)

# Rule 1
rule1 = Rule1(y, lcl = qcclimits$lcl, ucl = qcclimits$ucl, sides = 1)
points(x[c(rule1) > 0], y[c(rule1) > 0], pch = 0, cex = 1.2, col = cb_vermillion)

# Rule 2
rule2 = Rule2(y, cl = qcclimits$cl, npoints = 9)
points(x[c(rule2) > 0], y[c(rule2) > 0], pch = 1, cex = 1.2, col = cb_blue)

# Rule 3
rule3 = Rule3(y, nPoints = 6, convention = 1, equalBreaksSeries = 1)
points(x[c(rule3) > 0], y[c(rule3) > 0], pch = 2, cex = 1.2, col = cb_bluishgreen)

# Rule 4
rule4 = Rule4(y, nPoints = 14, convention = 1)
points(x[c(rule4) > 0], y[c(rule4) > 0], pch = 5, cex = 1.2, col = cb_yellow)

# Rule 5
rule5 = Rule5(y, zoneB = zoneborders, minNPoints = 2, nPoints = 3)
points(x[c(rule5) > 0], y[c(rule5) > 0], pch = 6, cex = 1.2, col = cb_skyblue)

# Rule 6
rule6 = Rule6(y, zoneB = zoneborders, minNPoints = 4, nPoints = 5)
points(x[c(rule6) > 0], y[c(rule6) > 0], pch = 0, cex = 1.2, col = cb_reddishpurple)

# Rule 7
rule7 = Rule7(y, zoneB = zoneborders, nPoints = 15)
points(x[c(rule7) > 0], y[c(rule7) > 0], pch = 1, cex = 1.2, col = cb_orange)

# Rule 8
rule8 = Rule8(y, zoneB = zoneborders, nPoints = 8)
points(x[c(rule8) > 0], y[c(rule8) > 0], pch = 2, cex = 1.2, col = cb_blue)

mtext('Number of Violations per Rule', side=1, line=4)

mtextoffset = 17.5
mtext(paste("Rule 1:", sum(rule1)), side=1, line=5, at= 0 + mtextoffset, adj = 1)
mtext(paste("Rule 2:", sum(rule2)), side=1, line=6, at= 0 + mtextoffset, adj = 1)
mtext(paste("Rule 3:", sum(rule3)), side=1, line=5, at=20 + mtextoffset, adj = 1)
mtext(paste("Rule 4:", sum(rule4)), side=1, line=6, at=20 + mtextoffset, adj = 1)

mtext(paste("Rule 5:", sum(rule5)), side=1, line=5, at=40 + mtextoffset, adj = 1)
mtext(paste("Rule 6:", sum(rule6)), side=1, line=6, at=40 + mtextoffset, adj = 1)
mtext(paste("Rule 7:", sum(rule7)), side=1, line=5, at=60 + mtextoffset, adj = 1)
mtext(paste("Rule 8:", sum(rule8)), side=1, line=6, at=60 + mtextoffset, adj = 1)

sumofruleviolations = sum(rule1) + sum(rule2) + sum(rule3) + sum(rule4) + sum(rule5) + sum(rule6) + sum(rule7) + sum(rule8) 
numberofrulesviolated = 0
if (sum(rule1) > 0) {numberofrulesviolated = numberofrulesviolated + 1}
if (sum(rule2) > 0) {numberofrulesviolated = numberofrulesviolated + 1}
if (sum(rule3) > 0) {numberofrulesviolated = numberofrulesviolated + 1}
if (sum(rule4) > 0) {numberofrulesviolated = numberofrulesviolated + 1}
if (sum(rule5) > 0) {numberofrulesviolated = numberofrulesviolated + 1}
if (sum(rule6) > 0) {numberofrulesviolated = numberofrulesviolated + 1}
if (sum(rule7) > 0) {numberofrulesviolated = numberofrulesviolated + 1}
if (sum(rule8) > 0) {numberofrulesviolated = numberofrulesviolated + 1}

mtext(paste("rule violations:"),    side=1, line=5, at=90 + mtextoffset, adj = 1)
mtext(paste("vioalted rules:"),     side=1, line=6, at=90 + mtextoffset, adj = 1)
mtext(paste(sumofruleviolations),   side=1, line=5, at=98 + mtextoffset, adj = 1)
mtext(paste(numberofrulesviolated), side=1, line=6, at=98 + mtextoffset, adj = 1)

# Histogram part
par(mar=c(7,0,2,4))
par(fig=c(0.7,1,0,1), new = TRUE)

xfit <- seq(min(y), max(y), length.out = N)
yfit <- dnorm(xfit, mean = mean(y), sd = sd(y))
yfit <- yfit * diff(h$mids[1:2]) * length(y)

plot(yfit, xfit, type = 'l', lwd = 0.01, axes = FALSE, 
     xaxs="i", xlab="", xlim = c(0,ceiling(1.2*max(h$counts)/10)*10),
     yaxs="i", ylab="", ylim = c(ylimmin,ylimmax),
     panel.first = c (abline(mean(y),0,         col = cb_darkgrey,  lty = 1),
                      abline(mean(y)+1*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)-1*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)+2*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)-2*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)+3*sd(y),0, col = 'gray50', lty = 3),
                      abline(mean(y)-3*sd(y),0, col = 'gray50', lty = 3),
                      
                      abline(14,0, col = cb_blue, lty = 2),
                      abline(6, 0, col = cb_blue, lty = 2))
     )
axis(1)
axis(4)

mtext('property', side = 4, line = 2)
mtext('counts', side = 1, line = 2)

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
box()

if (make_tikz) dev.off()
