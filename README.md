GetCleanDataProject
===================

The course project for the Coursera Getting and Cleaning Data Course

How The Script Works
====================

- Downloads the .zip and extracts all files.
- Reads all relevant data into R
- Merges the testing/training data sets but keeps data, activity and subject information seperate for now.
- Reads in the list of features and selects only those which feature "mean" or "std" as part of their descriptor. These are the only measurements we need.
- Takes a subset of the full original dataset to only use those relating the mean or standard deviation measurements
- Converts the numeric activity information into a human readable word.
- Tidied up the column names to make them more human readable (everything to lower case, replace some abbreviations with a full word, specifies time domain vs frequency domain).
- Adds the subject and activity information onto the full data frame and writes to text.
- For each subject/activity pair, get all of the relevant rows and takes a mean over the columns.
- Gives the subject/activity pair columns readable headings.
- Writes to a matrix.

Codebook
========

The attached file codebook.txt gives an update to the existing codebooks to explain the data format
