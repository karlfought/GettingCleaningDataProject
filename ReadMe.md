---
title: "ReadMe Getting and Cleaning Data Course Project"
author: "Karl Fought"
date: "Sunday, April 26, 2015"
output: html_document
---

#Summary
This read me file explains the processing steps used to create the tidy data set (summarisedfinaldata.txt) that is the final output of running the run_analysis.R script in this repository.

#Pre-requisites
Before executing the script the data must be downloaded from the below url. The zip file should be Extracted to the working directory so that the run_analysis.R file and the extracted "UCI HAR Dataset" folder are in the same directory. 

Data URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Processing
Once the data has been downloaded the script can be run which will perform the following steps:
1. Dplyr and Rattle packages are installed and loaded.
2. Data directories are set.
3. Activity label and Feature listing data are read.
4. Activity data are named for easier mapping.
5. Test raw data, Activityid data and subject data are read.
6. Features list (column headers) are added to the raw test data.
7. Subject and ActivityID are added the to Raw Test data.
8. Unnecessary duplicate columns are removed from the data set.
9. Dataset is reduced to only the mean and standard deviation variables.
10. Steps 5-9 are repeated with the training data.
11. Once the test and training data sets have had the first pass at cleaning, they are merged.
12. Activity names are added to the combined dataset.
13. Dataset is further cleaned of unnecessary variables.
14. Variable names are extracted from the dataset and normalized and cleaned to make more human readable.
15. Cleaned data set is then summarised by Subject and Activity with the mean of each variable provided in the final dataset.
16. Dataset is written to summarisedfinaldata.txt

Information about variables summarised can be found in the file Codebook.txt contained in this repository.