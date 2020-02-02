source('pkg/initalize.R', local = TRUE)

make_tikz = TRUE
if (make_tikz) tikzRexport('ParetoDiagram.tex')

# c(bottom, left, top, right) to set margins
par(mar=c(7,6,2,6))

data <- read.csv('/home/christian/Dokumente/Programme/R/ParetoDiagramm/data/pareto_data.csv', header = TRUE)
yprop = data$defect[order(decreasing = TRUE, data$defect)]
csumvec = 100*cumsum(yprop)/sum(yprop)

bp = barplot(yprop,
             axes = TRUE,
             col = c(cb_vermillion, cb_orange, cb_bluishgreen, cb_blue),
             names.arg = data$category,
             ylim = c(0, ceiling(max(cumsum(yprop))/10)*10+10)
)
abline(h = c(0,cumsum(yprop)), lty=2, col = 'gray')
lines(bp, cumsum(yprop), type = "b", cex = 0.7, pch = 19, col = cb_darkgrey)
axis(4, at=c(0,cumsum(yprop)), labels = paste(c(0, round(csumvec))), las=2)

mtext("main error causes",         side=3, line=0.5,  cex = 1.5)
mtext("accumulated frequency [%]", side=4, line=3,    cex = 1.25)
mtext("number of defects",         side=2, line=3,    cex = 1.25)
mtext("number",                    side=1, line=1.85,             at=0, adj = 1)
mtext("frequency",                 side=1, line=2.85,             at=0, adj = 1)
mtext("acc. frequency",            side=1, line=3.85,             at=0, adj = 1)
mtext("defect type",               side=1, line=6,    cex = 1.25)

axis(4, at=bp,     labels = paste(yprop),                              side=1, col = NA, line=0.85, hadj = 1)
axis(4, at=bp+0.2, labels = paste(format(round(100*yprop/sum(yprop), 1), nsmall = 1),'%'), side=1, col = NA, line=1.85, hadj = 1)
axis(4, at=bp+0.2, labels = paste(format(round(csumvec, 1), nsmall = 1),'%'),              side=1, col = NA, line=2.85, hadj = 1)
box()

if (make_tikz) dev.off()
