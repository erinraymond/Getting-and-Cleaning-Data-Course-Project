# run_analysis.R script does the following:

## 1. Reads the following downloaded files and creates dataframes
   * activity_labels.txt
   * features.txt
   * Y_test.txt
   * Y_train.txt
   * subject_test.txt
   * subject_train.txt
   * X_test.txt
   * X_train.txt

## 2. Combines data
   * Combines test and train data using rbind()
   * Adds names to columns
   * Updates Activity column with descriptions

## 3. Extracts only the measurements on the mean and standard deviation for each measurement
   * The SubsetFeatures vector is created with the measurement columns and then subset() creates a SubsetFeaturesData dataframe with the columns needed
   * cbind() is then used to combine this data with the subjects and activities

## 4. Appropriately labels the data set with descriptive variable names. 
   * Characters are removed from column names using gsub

## 5. From the data set in step 4, creates a second, independent tidy data set (CombinedTidy) with the average of each variable for each activity and each subject
   * This is done using the dyplr commands group_by() and summarize_each()
   * This dataset is written to a text file called tidydata.txt