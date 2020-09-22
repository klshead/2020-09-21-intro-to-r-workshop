#   _____ _             _   _                        _ _   _       _____        _        
#  / ____| |           | | (_)                      (_| | | |     |  __ \      | |       
# | (___ | |_ __ _ _ __| |_ _ _ __   __ _  __      ___| |_| |__   | |  | | __ _| |_ __ _ 
#  \___ \| __/ _` | '__| __| | '_ \ / _` | \ \ /\ / | | __| '_ \  | |  | |/ _` | __/ _` |
#  ____) | || (_| | |  | |_| | | | | (_| |  \ V  V /| | |_| | | | | |__| | (_| | || (_| |
# |_____/ \__\__,_|_|   \__|_|_| |_|\__, |   \_/\_/ |_|\__|_| |_| |_____/ \__,_|\__\__,_|
#                                    __/ |                                               
#                                   |___/                                                
#
# Based on: https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html



# Lets download some data (make sure the data folder exists)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

# now we will read this "csv" into an R object called "surveys"
surveys <- read.csv("data_raw/portal_data_joined.csv")

# and take a look at it
surveys
head(surveys)    #shows you the top of the table
View(surveys)

# BTW, we assumed our data was comma separated, however this might not
# always be the case. So we may been to tell read.csv more about our file.



# So what kind of an R object is "surveys" ?
class(surveys)


# ok - so what are dataframes ?
str(surveys)    #tells us all the meta information that R knows about "surveys"
dim(surveys)    #tells us the dimensions of the data
nrow(surveys)   #tells you the number of rows
ncol(surveys)   #tells you the number of columns

head(surveys, 2)  #lets you control how many rows it shows
summary(surveys)  #gives you a bunch of statistics about the data

# --------
# Exercise
# --------
#
# What is the class of the object surveys?
# 
# Answer:
# dataframe

# How many rows and how many columns are in this survey ?
#
# Answer:
# rows: 34786, columns: 13

# What's the average weight of survey animals
#
#
# Answer:
mean(surveys$weight, na.rm = TRUE)
# 42.67243
# or find it in the summary function

# Are there more Birds than Rodents ?
#
#
# Answer: nope


# 
# Topic: Sub-setting
#

# first element in the first column of the data frame (as a vector)
surveys[1,1]

# first element in the 6th column (as a vector)
surveys[1,6]

# first column of the data frame (as a vector)
surveys[, 1]

# first column of the data frame (as a data frame)
surveys[1]

# first row (as a data frame)
surveys[1, ]    #can't do it as a vector, bc there are many data types

# first three elements in the 7th column (as a vector)
surveys[1:3, 7]

# the 3rd row of the data frame (as a data.frame)
surveys[3, ]

# equivalent to head(metadata)
surveys[1:6, ]

# looking at the 1:6 more closely
1:6     # 1 2 3 4 5 6
surveys[c(1, 2, 3, 4, 5, 6), ]
surveys[ c(2,4,5), ]

# we also use other objects to specify the range
rows <- 6
surveys[1:6, 3]
surveys[1:rows, 3]

#
# Challenge: Using slicing, see if you can produce the same result as:
#
#   tail(surveys)
#
# i.e., print just last 6 rows of the surveys dataframe
#
# Solution:
surveys[34781:34786, ]
nrow(surveys)
a <- nrow(surveys)-5
surveys[a:nrow(surveys), ]
#or
surveys[(nrow(surveys)-5):nrow(surveys), ]

# We can omit (leave out) columns using '-'
surveys[-1]
surveys[-1, -2, -3]
head(surveys[c(-1, -2, -3)])
head(surveys[ -(1:3)])

# column "names" can be used in place of the column numbers
surveys["month"]


#
# Topic: Factors (for categorical data)
# 
sex <- factor( c("male", "male", "female"))
levels(sex)
nlevels(sex)

# factors have an order
temperature <- factor( c("hot", "cold", "cold", "warm"))
temperature[1]   #levels are put in alphabetical order
    # you can set the order of the levels
temperature <- factor( c("hot", "cold", "cold", "warm"), 
                       level= c("cold", "warm", "hot") )
levels(temperature)

# Converting factors
as.numeric(temperature)
as.character(temperature)

# can be tricky if the levels are numbers
year <- factor( c(1990, 1983, 1977, 1998, 1990))
as.numeric(year)
as.character(year)
as.numeric(as.character(year))

# so does our survey data have any factors
str(surveys)   #columns will be marked with their data type

#
# Topic:  Dealing with Dates
#

# R has a whole library for dealing with dates ...
library(lubridate)

my_date <- ymd("2015-01-01")

# date 7-16-1977

# R can concatenated things together using paste()
paste("abc", "123", sep = "-")
ymd( paste("2015", "01", "01", sep = "-"))   
  # this is no longer a character string, it's a date
        class(ymd( paste("2015", "01", "01", sep = "-")))

# 'sep' indicates the character to use to separate each component


# paste() also works for entire columns
paste(surveys$year, surveys$month, surveys$day)
paste(surveys$year, surveys$month, surveys$day, sep = "-")

ymd(paste( surveys$year, 
           surveys$month, 
           surveys$day, sep = "-"))

# let's save the dates in a new column of our dataframe surveys$date 
#to create a new column from this combined date
surveys$date <- ymd(paste( surveys$year, 
                          surveys$month, 
                          surveys$day, sep = "-"))

# and ask summary() to summarise 
summary(surveys)

# but what about the "Warning: 129 failed to parse"
# some data cannot be converted to a date, we have 129 NAs
summary(surveys$date)
missing_dates <- surveys[is.na(surveys$date), "date"]
missing_dates <- surveys[is.na(surveys$date), 
                         c("date", "year", "month", "day")]
missing_dates

# these dates are 31st of months that don't have 31 days
#to find the references
missing_dates <- surveys[is.na(surveys$date), 
                         c("record_id", "year", "month", "day")]
missing_dates
