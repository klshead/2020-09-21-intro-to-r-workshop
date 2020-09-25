# Visualising Data with ggplot2

# load ggplot

library(ggplot2)
library(tidyverse)

# could also load tidyverse, because it contains ggplot2

# load data

surveys_complete <- read_csv("data_raw/surveys_complete.csv")

# create plot

ggplot(data = surveys_complete)
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
       geom_point()

# give it the data, the x and y axis (mapping), and the display type (geom)

# assign a plot to a variable

surveys_plot <- ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))

# draw the plot

surveys_plot +
  geom_point()

# Challenge 1: Change the mappings so weight is on the y-axis and hindfoot_length is on the x-axis

ggplot(data = surveys_complete, mapping = aes(x = hindfoot_length, y = weight)) +
  geom_point()

# Challenge 2: How would you create a histogram of weights?

hist(surveys_complete$weight) # lol, she wasnted us to use ggplot, but didn't specify

ggplot(data = surveys_complete, mapping = aes(weight)) +
  geom_histogram()

# can also give the binwidth

ggplot(data = surveys_complete, mapping = aes(weight)) +
  geom_histogram(binwidth = 10)

