CodeBook

This code book describes the variables, the data, and transformations performed to clean up the data for the course project.

The name of the script is run_analysis.R

1.  First, download the data from the following url:
myurl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

2.  We record the date and time the data was downloaded and write it out to metadata.txt.

3.  We then extract the components of the zip file.  This process creates a directory named "UCI HAR Dataset"
directly below the current working directory, creating subdirectories as necessary.

4.  In order to create descriptive variable names, we read these from the file features.txt into a vector
to use as col.names when we read in the actual data.

5.  Next we read in the test data, then the training data.  We then use rbind to combine the two data sets.

6.  The activity codes are stored in two different files, one for the test data and one for the training data.
First we read in those for test, then traning, and again use rbind to combine them.  We are careful to specify
the same order of operations so that the activity codes match up to data. We use cbind to combine this vector
with the data set (activity code becomes the first column).

7.  Similarly, the subject identifiers are also in separate files and we read these in to create the vector of
subject identifiers.  We again use cbind to combine this vector of subject identifiers with our growing data 
frame.  subject_id becomes the first column.

8.  The translation of activity codes into activity names is contained in yet another file.  We read this file
into a data frame named Lookup.  We use plyr to join these two data frames by activity_code.  This adds the 
activity column to our large data set.  We then rearrange the order of the columns so that subject_id is first,
activity is second, and activity_code is third.

9.  To extract data which only provides the mean and standard deviation, we use grep to create a vector of the
variable names of interest.  From that vector, we subset to exclude the first three ID columns.  We then use
melt to reshape the data into a long data set and then use dcast to reshape that molten set, specifying 
subject_id and activity as the id columns, our variable names vector as the measure columns, and mean as the 
function to apply.  This produces the final result: a tidy data set with the average of each variable for each 
activity and each subject.
