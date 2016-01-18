#Code Book


To obtain the tidy dataset from the original data, the following transformations were performed:

1. All training and test data sets were merged to form a single data set. The particular files used were "X_test.txt", "X_train.txt", "Y_test.txt", "Y_train.txt", "subject_test.txt", and "subject_train.txt".

2. The data table was filtered to only include those variables that measured either mean or standard deviation. There are 64 such variables.

3. Activity names, obtained from activity_labels.txt, were added into the data table.

4. Variables in the data table were renamed to be more descriptive. The following changes were made:
  * "t" was replaced with time
  * "f" was replaced with frequency
  * "Acc" was replaced with Accelerometer
  * "Gyro" was replaced with Gyroscope
  * "Mag" was replaced with Magnitude

5. Finally, the tidy data set, called tidydata.txt, was created.
  * The mean value was calculated for each variable broken down by subject and activity. 
  * The data were reordered by subject and then by activity.
  * A data table was written.
  * When the user runs the R script, the data table is opened.

No other modifications nor transformations were performed on the data.




