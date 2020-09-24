#####################
# MANIPULATING DATA #
#       using       #
#     TIDYVERSE     #
#####################
#
#
# Based on: https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

# Data is available from the following link (we should already have it)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

#---------------------
# Learning Objectives
#---------------------

#    Describe the purpose of the dplyr and tidyr packages.
#    Select certain columns in a data frame with the dplyr function select.
#    Select certain rows in a data frame according to filtering conditions with the dplyr function filter .
#    Link the output of one dplyr function to the input of another function with the ‘pipe’ operator %>%.
#    Add new columns to a data frame that are functions of existing columns with mutate.
#    Use the split-apply-combine concept for data analysis.
#    Use summarize, group_by, and count to split a data frame into groups of observations, apply summary statistics for each group, and then combine the results.
#    Describe the concept of a wide and a long table format and for which purpose those formats are useful.
#    Describe what key-value pairs are.
#    Reshape a data frame from long to wide format and back with the pivit_wider and pivit_longer commands from the tidyr package.
#    Export a data frame to a .csv file.
#----------------------

#------------------
# Lets get started!
#------------------
install.packages("tidyverse")
library(tidyverse)
# dplyr and tidyr (allow you to reshape your data for plotting)

# load the dataset
surveys <- read_csv("data_raw/portal_data_joined.csv")

# check structure
str(surveys)

#-----------------------------------
# Selecting columns & filtering rows
#-----------------------------------
select(surveys, plot_id, species_id, weight)
# you need to make sure you're using the dplyr version

# if you want all columns but two
select(surveys, -record_id, -species_id)

# filter for a particular year
filter(surveys, year == 1995)
surveys_1995 <- filter(surveys, year == 1995)

surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)
surveys_sml <- select(filter(surveys, weight < 5), species_id, sex, weight)

#-------
# Pipes
#-------
# The pipe --> %>%
# Shortcut is command + shift + m
surveys %>% 
  filter (weight < 5) %>% 
  select(species_id, sex, weight)

# This does the same thing as the section above
surveys_sml <- surveys %>% 
  filter (weight < 5) %>% 
  select(species_id, sex, weight)

surveys_sml2 <- surveys %>% 
  select(species_id, sex, weight) %>% 
  filter(weight < 5)
# (therefore, order probably does not matter, but in general go with the first order)
# filter before select


#-----------
# CHALLENGE
#-----------

# Using pipes, subset the ```surveys``` data to include animals collected before 1995 and 
# retain only the columns ```year```, ```sex```, and ```weight```.

surveys_challenge <- surveys %>% 
  filter(year < 1995) %>% 
  select(year, sex, weight) 
# the order you put the columns in is the order they will appear in  


#--------
# Mutate
#--------
# handy to convert one column into another column without rewriting it
surveys %>% 
  mutate(weight_kg = weight / 1000)
# mutate(new column = transformed column + transformation)

surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg * 2.2)

surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight / 1000) %>% 
  head(20)

#-----------
# CHALLENGE
#-----------

# Create a new data frame from the ```surveys``` data that meets the following criteria: 
# contains only the ```species_id``` column and a new column called ```hindfoot_cm``` containing 
# the ```hindfoot_length``` values converted to centimeters. In this hindfoot_cm column, 
# there are no ```NA```s and all values are less than 3.

# Hint: think about how the commands should be ordered to produce this data frame!

surveys_feet <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  mutate(hindfoot_cm = hindfoot_length / 10) %>% 
  filter(hindfoot_cm < 3) %>% 
  select(species_id, hindfoot_cm)



#---------------------
# Split-apply-combine
#---------------------

surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE))

# for a summary of data it's summary() not summarise()
# for summarise() you have to tell it what sort of summary you'd like

surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight)) %>% 
  print(n = 20)
# print(n = ) gives how many it will show

surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
  arrange(desc(mean_weight)) 
# ascending order it the default, to send it big --> small you have to specify desc
# can also use arrange(-(mean_weight))

surveys %>% 
  count(sex)

surveys %>% 
  group_by(sex) %>% 
  summarise(count = n())     # gives the same result as above

surveys %>% 
  group_by(species_id, sex, taxa) %>% 
  summarise(count = n())     # will group in order that they are placed in

surveys_new <- surveys %>% 
  group_by(sex, species_id, taxa) %>% 
  summarise(count = n())

surveys_new %>% 
  summarise(mean_weight = mean(weight))  #notice, we have excluded weight in the previous code

#-----------
# CHALLENGE
#-----------

# 1. How many animals were caught in each ```plot_type``` surveyed?
surveys %>% 
  group_by(plot_type) %>% 
  summarise(count = n())

# 2. Use ```group_by()``` and ```summarize()``` to find the mean, min, and max hindfoot length 
#    for each species (using ```species_id```). Also add the number of observations 
#    (hint: see ```?n```).
surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  group_by(species_id) %>% 
  summarise(mean_length = mean(hindfoot_length),
            min_length = min(hindfoot_length),
            max_length = max(hindfoot_length),
            count = n())

# 3. What was the heaviest animal measured in each year? 
#    Return the columns ```year```, ```genus```, ```species_id```, and ```weight```.
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(year) %>%
  filter(weight == max(weight)) %>%  
  select(year, genus, species, weight) %>%
  arrange(year)

surveys %>% 
  select(year, genus, species_id, weight) %>%
  group_by(year) %>%
  top_n(1, weight) %>%
  arrange(year)

surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(year) %>%
  filter(weight == max(weight)) %>% 
  select(year, genus, species, weight) %>%
  arrange(year) %>% 
  distinct()

#-----------
# Reshaping
#-----------
# it resorts rows and columns

surveys_gw <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(plot_id, genus) %>% 
  summarise(mean_weight = mean(weight))

surveys_wider <- surveys_gw %>% 
  spread(key = genus, value = mean_weight)

# key is what you want to pivot on/spread out across the top of the table/create columns on
# values are what you're organising underneath these new columns
# pivot_wider is the new name of this function and it uses different terms

surveys_gather <- surveys_wider %>% 
  gather(key = genus, value = mean_weight, -plot_id)

# sometimes this gathers NAs, be careful

surveys_gather2 <- surveys_wider %>% 
  gather(key = genus, value = mean_weight, Baiomys:Spermophilus)

#-----------
# CHALLENGE
#-----------

# 1. Spread the surveys data frame with year as columns, plot_id as rows, 
#    and the number of genera per plot as the values. You will need to summarize before reshaping, 
#    and use the function n_distinct() to get the number of unique genera within a particular chunk of data. 
#    It’s a powerful function! See ?n_distinct for more.

surveys_spread_genera <- surveys %>% 
  group_by(plot_id, year) %>% 
  summarise(n_genera = n_distinct(genus)) %>% 
  spread(year, n_genera)

head(surveys_spread_genera)
  

# 2. Now take that data frame and gather() it again, so each row is a unique plot_id by year combination.

surveys_spread_genera2 <- surveys_spread_genera %>% 
  gather(key = year, value = n_genera,-plot_id)

head(surveys_spread_genera2)
  
# 3. The surveys data set has two measurement columns: hindfoot_length and weight. 
#    This makes it difficult to do things like look at the relationship between mean values of each 
#    measurement per year in different plot types. Let’s walk through a common solution for this type of problem. 
#    First, use gather() to create a dataset where we have a key column called measurement and a value column that 
#    takes on the value of either hindfoot_length or weight. 
#    Hint: You’ll need to specify which columns are being pivoted.

surveys_long <- surveys %>% 
  gather("measurement", "value", hindfoot_length, weight)

head(surveys_long)

# 4. With this new data set, calculate the average of each measurement in each year for each different plot_type. 
#    Then spread() them into a data set with a column for hindfoot_length and weight. 
#    Hint: You only need to specify the key and value columns for spread().

surveys_long2 <- surveys_long %>% 
  group_by(year, measurement, plot_type) %>% 
  summarise(mean_value = mean(measurement, na,rm = TRUE)) %>% 
  spread(measurement, mean_value)

head(surveys_long2)

#this did not work...


# when using pivot_longer and pivot_wider you use names_from and values_from, respectively

#----------------
# Exporting data
#----------------


write_csv(surveys_long, path = "data_out/surveys_long.csv")








