# /usr/bin/r
#
# Copyright 2019-2019 Steven E. Pav. All Rights Reserved.
# Author: Steven E. Pav 
#
# copied from https://raw.githubusercontent.com/HughParsonage/latex-travis/master/install_texlive.R
# cf 
# https://tex.stackexchange.com/a/414739/2530
#
# Created: 2019.11.13
# Copyright: Steven E. Pav, 2019
# Author: Steven E. Pav <steven@gilgamath.com>
# Comments: Steven E. Pav

if (!requireNamespace("tinytex", quietly = TRUE)) {
	if (!requireNamespace("devtools", quietly = TRUE)) {
		install.packages("jsonlite", repos = "https://cran.rstudio.com/", quiet = TRUE)
		install.packages("httr", repos = "https://cran.rstudio.com/", quiet = TRUE)
		install.packages("memoise", repos = "https://cran.rstudio.com/", quiet = TRUE)
		install.packages("devtools", repos = "https://cran.rstudio.com/", quiet = TRUE)
		cat('devtools installed\n')
	}
  devtools::install_github(c('yihui/tinytex'), quiet = TRUE)
	tinytex::install_tinytex()
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
