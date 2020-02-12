library(tikzDevice)

if(packageVersion("tikzDevice") < "0.10.2") {
  message('You need to update "tikzDevice" to version 0.10.2 at least')
  message('use: install.packages("tikzDevice")')
}

# use luatex as default engine
options(tikzDefaultEngine = 'luatex')

# forcing the use of lualatex (most editors understand that)
options(tikzDocumentDeclaration = c('% !TEX TS-program = lualatex\n',
                                    '\\documentclass{standalone}%\n\n'))

# make package requirements similar to matlab2tikz
options(tikzLualatexPackages = c('\\RequirePackage{luatex85}%',
                                 '\\usepackage{pgf}%',
                                 '\\usepackage{tikz}%',
                                 '\\usepackage{siunitx}%',
                                 '\\usepackage{grffile}%\n',
                                 '\\usetikzlibrary{calc}%',
                                 '\\usepackage[utf8]{inputenc}%',
                                 '\\usepackage{amssymb}%',
                                 '\\usepackage{amsfonts}%\n\n'
                                 #'\\usepackage[active,tightpage,psfixbb]{preview}\n',
                                 #'\\PreviewEnvironment{pgfpicture}\n'
                                 ))

options(tikzUnicodeMetricPackages = c('\\usetikzlibrary{calc}',
                                      '\\usepackage[utf8]{inputenc}',
                                      '\\usepackage{amssymb}',
                                      '\\usepackage{amsfonts}'))

# print out the used settings (for testing)
#getOption( 'tikzLualatexPackages' )
#getOption( 'tikzUnicodeMetricPackages' )

# This program is called with the filename as parameter only
tikzRexport <- function(filename) {
  # Check if RStudio is used and get the current folder 
  # and filename of this Script. Currently, there is no
  # else part which will produce an error if RStudio i not used.
  # At the moment I can't even confirm if this is running on all OS.

  if (rstudioapi::isAvailable()) {
    currentscriptpath = dirname(rstudioapi::getSourceEditorContext()$path)
    currentscriptname = basename(rstudioapi::getSourceEditorContext()$path)
  }

  # Some folder and file operations. Creating a folder called tikz
  # in the directory of the main program.
  tikz_path = file.path(currentscriptpath, 'tikz')
  dir.create(file.path(tikz_path), showWarnings = FALSE)
  tikzTEX_path_and_filename = file.path(tikz_path, filename)
  
  # The main tikz export command.
  tikz(tikzTEX_path_and_filename, standAlone = TRUE, sanitize = TRUE)
}
