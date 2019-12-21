if(!is.null(dev.list())) dev.off()
graphics.off()

# delete every variable
remove(list = ls())

#tikz_path = '/home/user/R/demoBoxplot/tikz/'
#tikz_filename = 'demoBoxplot.tex'

#dir.create(file.path(tikz_path), showWarnings = FALSE)
#tizeTEX_path_and_filename = paste(tikz_path, tikz_filename)

#require(tikzDevice)
#tikz(tizeTEX_path_and_filename, standAlone = TRUE, width=5, height=5)

N = 40
set.seed(5)
y = rnorm(N)
y[N-0] <- -5
y[N-1] <- 8
x <- c(1:N)*0 + 1

set.seed(50)
z <- rnorm(N)
z[N-0] <- -5
z[N-1] <- 5

groups = cbind(x,x+1)
data = cbind(y,z)

boxplot(data~groups,
        outline = FALSE,
        horizontal = TRUE,
        notch = TRUE,
        varwidth = TRUE,
        staplewex = 0.1,
        ylab = 'group',
        xaxt="n",
        yaxt="n",
        xlim = c(0.5, 2.5),
        ylim = c(-6,9),
        whisklty = 1,
        col = rgb(0, 158, 115, max=255),
        main='Boxplot with marked outliers'
)
axis(1, at=seq(-6,8,2),labels=seq(-6,8,2), col.axis="black", las=1)
axis(2, at=seq(1,2,1),labels=seq(1,2,1), col.axis="black", las=2)

# show the mean value as white filled circle
for (inx in 1:2) {
        points(mean(data[1:40,inx]), inx, pch=19, cex=1.5, col = 'white')
}

bp = boxplot(data~groups, plot=FALSE)

# Calculate the the difference between the lower (bp$stats[2]) and 
# upper hinge (bp$stats[2]) to determine the IQR. Doing that for every 
# outlier (through bp$group) is an elegant method to avoid using a loop.
# Note that group here is a return value of boxplot that contains the 
# corresponding group of all outliers.
df = cbind(bp$stats[2,bp$group], bp$stats[4,bp$group])
IQR <- apply(df, 1, function(x) diff(range(x)))

# To differently mark the outliers we just need to know which of them
# are beyond 3 IQR, the others are obviously within 1.5 and 3 IQR.
          #bp$out > abs(bp$stats[4,bp$group])+3*IQR | abs(bp$out) > abs(bp$stats[2,bp$group])+3*IQR
extreme <- bp$out > abs(bp$stats[4,bp$group])+3*IQR | abs(bp$out) > abs(bp$stats[2,bp$group])+3*IQR

# using blue circles for mild outliers and a red cross for extreme outliers
points(bp$out, bp$group, 
       pch=ifelse(extreme, 3, 1), 
       col=ifelse(extreme, rgb(213,94,0, max=255), rgb(0,114,178, max=255)), 
       cex=1.25
)

# show all data points, reverse call as result of horizontal bar plot
points(groups~data, pch = 20, cex = 1, col = rgb(50,50,50, max=255))

# lines to show all positions of the stats and conf matrix of boxplot
# idx can be 0 to max(number of groups) while 0 disables that function
idx = 0
abline(v = bp$stats[1,idx], col=rgb(50,50,50, max=255), lwd=1, lty='solid')
abline(v = bp$stats[2,idx], col=rgb(50,50,50, max=255), lwd=1, lty='solid')
abline(v = bp$stats[3,idx], col=rgb(50,50,50, max=255), lwd=1, lty='solid')
abline(v = bp$stats[4,idx], col=rgb(50,50,50, max=255), lwd=1, lty='solid')
abline(v = bp$stats[5,idx], col=rgb(50,50,50, max=255), lwd=1, lty='solid')
abline(v = bp$conf[1,idx], col=rgb(50,50,50, max=255), lwd=1, lty='solid')
abline(v = bp$conf[2,idx], col=rgb(50,50,50, max=255), lwd=1, lty='solid')
 
#grid()
#dev.off()
