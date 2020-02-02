source('pkg/initalize.R', local = TRUE)
source('pkg/mark_outliers.R', local = TRUE)
source('pkg/show_data_points.R', local = TRUE)

make_tikz = TRUE
if (make_tikz) tikzRexport('demoBoxplot.tex')

N = 40

set.seed(5)
y = rnorm(N)
y[N-0] <- -5
y[N-1] <- 8

set.seed(50)
z <- rnorm(N)
z[N-0] <- -5
z[N-1] <- 5

groups = cbind(rep(1, N), rep(2, N))
data   = cbind(y, z)

boxplot(data~groups,
        outline    = FALSE,
        horizontal = TRUE,
        notch      = TRUE,
        varwidth   = TRUE,
        staplewex  = 0.1,
        xlab       = 'value',
        ylab       = 'group',
        xaxt       = "n",
        yaxt       = "n",
        xlim       = c(0.5, 2.5),
        ylim       = c(-6,9),
        whisklty   = 1,
        col        = rgb(0, 158, 115, max=255),
        main       = 'Boxplot with marked outliers'
)
axis(1, at = seq(-6,8,2), labels = seq(-6,8,2), col.axis="black", las=1)
axis(2, at= seq(1,2,1),   labels = seq(1,2,1),  col.axis="black", las=2)

# show the mean value as white filled circle
for (inx in 1:2) {
  points(mean(data[1:40,inx]), inx, pch=19, cex=1.5, col = 'white')
}

bp = boxplot(data~groups, plot=FALSE)

mark_outliers(data, groups)
show_data_points(data, groups, 0)

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
if (make_tikz) dev.off()
