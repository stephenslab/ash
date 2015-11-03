# Introduction

This repo is intended to contain code to reproduce results
from the paper 'False Discovery Rates: A New Deal'.

The hardest part may be making sure R is set up with all the right packages installed.
I have used the R package `packrat` to try to make this easier, but on some systems
it may be easier to install all the packages you need by hand. If things go wrong, look also at
[If things go wrong](#if-things-go-wrong).

Step-by-step instructions:

1. Preliminaries: I made the paper with `R v3.2.2`, so you might start by installing this version.  Install `pandoc v1.12.3` or higher. You will also need a working `pdflatex` installation to make the paper. Possibly other
dependencies you will come across as you run the following steps.
2. Clone (or download and unzip) this repository.
3. Install the `R` packages you need. I have tried to use the [`packrat`](https://rstudio.github.io/packrat/) package to automate this process, with some level of success. To do it this way, start up `R` (e.g. from the command line) within the repository directory. The first time you enter `R` the hidden `.Rprofile` file will cause `R` to try to install all the packages you need to a local library in the `packrat` subdirectory. (Specifically it should create a `packrat/lib` directory with more files in a subdirectory whose name will depend on your architecture.)  
If this does not work first time - e.g. because you don't have some dependencies installed - then install the dependencies and try again. This time on entering `R` you will have to tell `packrat` to try again yourself by typing `packrat::restore()`.
If this still does not work for you, or you already have the packages you need installed then you may prefer to remove the packrat subdirectory and install the packages you need yourself. Quit `R`.
4. Within the repository directory type `make`. This will try to:

      i) Run all the code for the simulation studies.
It will take a while (hours), so you might want to run it overnight. This should create a bunch of output files in the `output` directory. Particularly you will know that it worked iff you can find the files `dsc-shrink-files/res.RData` and `dsc-robust-files/dsc_robust.RData`.

      ii) Build/render the .Rmd files in the `analysis` directory. If successful you should have a file `analysis/index.html` that you can open to see a list of all the rendered files.

      iii)  `pdflatex` the paper.

If you have problems (more than likely!) you might like to try each of these steps in turn, by sequentially typing
`make output`, `make analysis`, and `make paper`.

# If things go wrong

- If things go wrong in making the output files, try looking at the `.Rout` files
created in  the appropriate output subdirectory (`output/dsc-shrink/`, `output/dsc-znull` or `output/dsc-robust`)
to see what went wrong.

- If things go wrong in making the analysis files, try looking at the `.hmtl` files produced to see what went wrong.

# Directory Structure

The directory structure here, and features of the `analysis` subdirectory (including the `Makefile`), are based on
[https://github.com/jdblischak/singleCellSeq](https://github.com/jdblischak/singleCellSeq).

Here's a brief summary of the directory structure.
- analysis: Rmd files for investigations; will generate figures in `figure/` subdirectory
- R: R scripts/functions used in analysis; no code that is actually run put here
- output: largish files of data, typically created by code (e.g. post-processed data, simulations)
- code: code used for preprocessing, generation of output files etc ; may be long-running
- data: datasets that generally will not change once deposited
- paper: the paper
- packrat: a directory that contains information about all the R package used.
See the R package `packrat` for more details.
- talks: any presentations
