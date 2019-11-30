# delete every variable
remove(list = ls())

require(tikzDevice)
tikz('Boxplot.tex', standAlone = TRUE, width=5, height=5)

N = 300
data = rnorm(n = N, mean = 0, sd = 1)
data[1] = 5; data[2] = -13; data[3] = -9; data[4] = 12; data[5] = 9;
data[6] = -6; data[7] = -8; data[8] = 13; data[9] = -4; data[10] = -14
groups = c(floor(runif(N/2,1,5)),floor(runif(N/2,3,5)))

# second handmade dataset
#data = c(2,6,9,-9,1,3,2,4,3,1,5,6,-2,4,-4,-8,0,1,-2,-1,4,14,-13,1,-1,0,4,3,6,30,-26,52,-52)
#groups = c(floor(runif(length(data),1,1)))

boxplot(data~groups,
        outline = FALSE,
        notch = TRUE,
        varwidth = TRUE,
        xlab = expression(groups),
        ylab = 'values',
        xlim = c(0, 5),
        ylim = c(-15, 15),
        main='Variable Width Notched Box Plot with Data Points \n and Highlighted Outliers',
        )

points(data~groups, pch = 20, cex = 0.5)
bp = boxplot(data~groups, plot=FALSE)

IQR <- abs(bp$stats[1,bp$group] - bp$stats[5,bp$group])
extreme <- bp$out >  3*IQR | bp$out < -3*IQR

points(bp$group+0.0, bp$out, 
       pch=ifelse(extreme, 3, 1), 
       col=ifelse(extreme, 2, 4), 
       cex=0.75
       )

legend('bottomleft', bty="0", legend=c('data', "1.5 to 3 IQR", "$>$ 3 IQR"),
       pch=c(20,1,4), col=c(1,4,2), pt.cex=c(0.5,0.75,0.75))

# showing in a not very dynamic way the number of elements per group
text(4.6, -7, labels = 'g', pos = 2)
text(5, -7, labels = 'n', pos = 2)
for(inx in 1:length(sort(unique(groups)))) {
  text(4.6, -8-(1+0.3)*inx, labels = toString(inx), pos = 2)
  text(5, -8-(1+0.3)*inx, labels = bp$n[inx], pos = 2)
}

dev.off()
tools::texi2dvi('Boxplot.tex', pdf=T)
