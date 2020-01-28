if(!is.null(dev.list())) dev.off()
graphics.off()

# delete every variable
remove(list = ls())

library(tikzDevice)

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

# manually paste the following two lines in the header of the tex file
# %!TEX TS-program = lualatex
# %!TeX encoding = utf8
#tikz_path = '/R/ParetoDiagramm/tikz/'
dir.create(file.path(tikz_path), showWarnings = FALSE)

tikz_filename = 'ParetoDiagram.tex'
tizeTEX_path_and_filename = paste(tikz_path, tikz_filename)
#tikz(tizeTEX_path_and_filename, standAlone = TRUE, sanitize = TRUE)

# c(bottom, left, top, right) to set margins
par(mar=c(7,6,2,6)) 

data <- read.csv('/R/ParetoDiagramm/data/pareto_data.csv', header = TRUE)
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

#dev.off()
