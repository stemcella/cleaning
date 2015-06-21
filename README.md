# tidyData 
To write conclusion first, I think I did not get right answer. I have tried to arrange data frame at last step, to get ordered column. but it seems like to failed. the subject column was not ordered correctly, (participant 10 is shown after participant 1. ) If you please let me know how to sort this type value(is not numeric.)  

###STEP0. DOWNLOADING FILES
To handle data frame easily, I employed dplyr package, 
url : the address for downloading data zip file.

### STEP1. MERGING DATA TABLE (561+3 columns, 7352+2947 rows)
train and test files were read from each source files. 
I made a "dataset" by rbind two data frames.   
column names of dataset was extracted from the features.txt file. 
the activity and subject column were made from "y_train,y_test.txt" and "subject_train,subject_test.txt" file. 
for identifying each dataset(train,test) I added one column named group. 
After that, all values are merged by cbind and named as fdata 

### STEP2. Extracting Mean and Std values (66+3 columns, 7352+2947 rows)
To extract the column contains the value related to "mean" and "std", I used select command. But this made unusual error. So I added a line to change the name as valid one. As result, I got the "Final" data frame have dimension (10299row, 69 col.)

### STEP3. Uses descriptive activity names to name the activities in the data set
substitute the activity names by information from "activity_label.txt"

### STEP4. Appropriately labels the data set with descriptive variable names.
changed the subject column to "participant" using for loop. 

### STEP5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
I made secondary tidy dataset by calculating mean values from each subject and activities,  group_by() %>% summarise_each() %>% arrange()  command made TidyData data frame.
the output file was written by write.table
