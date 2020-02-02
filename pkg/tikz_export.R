library(tikzDevice)

options(tikzDefaultEngine = 'luatex')

options(tikzDocumentDeclaration = c("% !TEX TS-program = lualatex\n",
                                    "\\documentclass{standalone}%\n\n"))

options(tikzLualatexPackages = c("\\RequirePackage{luatex85}%",
                                 "\\usepackage{pgf}%",
                                 "\\usepackage{tikz}%",
                                 "\\usepackage{siunitx}%",
                                 "\\usepackage{grffile}%\n",
                                 "\\usetikzlibrary{calc}%",
                                 "\\usepackage[utf8]{inputenc}%",
                                 "\\usepackage{amssymb}%",
                                 "\\usepackage{amsfonts}%\n\n"
                                 #"\\usepackage[active,tightpage,psfixbb]{preview}\n",
                                 #"\\PreviewEnvironment{pgfpicture}\n"
                                 ))

options(tikzUnicodeMetricPackages = c("\\usetikzlibrary{calc}",
                                      "\\usepackage[utf8]{inputenc}",
                                      "\\usepackage{amssymb}",
                                      "\\usepackage{amsfonts}"))

#getOption( "tikzLualatexPackages" )
#getOption( "tikzUnicodeMetricPackages" )

tikzRexport <- function(filename) {
  if (rstudioapi::isAvailable()) {
    currentscriptpath = dirname(rstudioapi::getSourceEditorContext()$path)
    currentscriptname = basename(rstudioapi::getSourceEditorContext()$path)
  }

  tikz_path = file.path(currentscriptpath, 'tikz')
  dir.create(file.path(tikz_path), showWarnings = FALSE)

  tikz_filename = filename
  tizeTEX_path_and_filename = file.path(tikz_path, tikz_filename)

  tikz(tizeTEX_path_and_filename, standAlone = TRUE, sanitize = TRUE)
}
