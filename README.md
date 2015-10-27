# Introduction

This repo is intended to contain code to reproduce results
from the paper 'False Discovery Rates: A New Deal'.

The hardest part may be making sure R is set up with all the right packages installed.
I have used the R package `packrat` to try to make this easier, but on some systems
it may be easier to install all the packages you need by hand.

Step-by-step instructions:

1. Install `R v3.2.2`.
2. Clone (or download and unzip) this repository.
3. Within this repository directory, enter `R`. It will try to use `packrat` to install all the packages you need.
If this does not work you may need to tell it to do this by hand by typing `packrat::restore()` within `R`.
If this does not work, you may prefer to remove the packrat subdirectory and install the packages you need yourself.
4. Enter the `code` directory (`cd code`) and type `make`. This should run all the code for the simulation studies.
It will take a while (hours), so you might want to run it overnight. This should create a bunch of output files in the `output` directory. 
5. Enter the `analysis` directory (`cd ../analysis`) and type `make`. This will create a bunch of
`html` output files, and also figures. You can open `analysis/index.html` to see a list of all the outputs created. 
6. Enter the `paper` directory (`cd ../paper`) and you should be able to latex the paper.


# Directory Structure

The directory structure here, and features of the `analysis` subdirectory (including the `Makefile`), are based on
[https://github.com/jdblischak/singleCellSeq](https://github.com/jdblischak/singleCellSeq).

Here's a brief summary of the directory structure.
- analysis: Rmd files for investigations; will generate figures in figure/ subdirectory
- R: R scripts/functions used in analysis; no code that is actually run put here
- output: largish files of data, typically created by code (eg postprocessed data, simulations)
- code: code used for preprocessing, generation of output files etc ; may be long-running
- data: datasets that generally will not change once deposited
- paper: the paper
- packrat: a directory that contains information about all the R package used.
See the R package `packrat` for more details.
- talks: any presentations
