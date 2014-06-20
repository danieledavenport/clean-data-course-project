clean-data-course-project
=========================

This is my Course Project repository for the Coursera Data Science course "Getting and Cleaning Data"

In addition to this README file, there is an R script named run_analysis.R which downloads and 
transforms the data into a tidy data set with the characteristics set out for the course project
as well as a code book file named CodeBook.md which describes how run_analysis.R gets the data,
shapes it, and produces the resulting data frame.  There is also a small file named metadata.txt
which is written to by the script and which captures the date and time the data is downloaded.
There are also two files which contain the results: result.txt (a tab delimited text file) and 
result.csv (a comma delimited text file).  The script itself produces a data frame object named result.
These text files were produced outside the script by writing the result data frame to an external
file.

Before running run_analysis.R, be sure to install the packages plyr and reshape2.  The script will
load the libraries as necessary.  To run the script, from the R command line run:
     source("run_analysis.R")
The script will download the data, shape it, and produce a data frame named result.
