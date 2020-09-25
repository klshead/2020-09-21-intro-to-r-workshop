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

# building plots iteratively

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1)
   # alpha changes the transparency/opacity of the points

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, colour = "purple")
   # can also use a hexcode for a colour

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, aes(colour = species_id))

# could also be written
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length, colour = species_id)) +
  geom_point(alpha = 0.1)

# Challenge 3: Use what you just learned to create a scatter plot of weight over species_id with the plot type showing in different colours. 
# Is this a good way to show this type of data?
  
ggplot(data = surveys_complete, mapping = aes(y = weight, x = species_id)) +
  geom_point(aes(colour = plot_type))
    # not good, better to use a boxplot, bc species_id is categorical

# Boxplots
# better when you have one discrete and one continuous variable

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot()

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, colour = "tomato")

# Challenge 4: Notice how the boxplot layer is behind the jitter layer? 
# What do you need to change in the code to put the boxplot in front of the points such that it’s not hidden?

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, colour = "tomato") +
  geom_boxplot(alpha = 0)
  # flip the order of geoms around

# Challenge 5: Boxplots are useful summaries but hide the shape of the distribution. 
# For example, if there is a bimodal distribution, it would not be observed with a boxplot. 
# An alternative to the boxplot is the violin plot (sometimes known as a beanplot), where the shape (of the density of points) is drawn.
# Replace the box plot with a violin plot

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_violin(alpha = 1, colour = "tomato")

# Challenge 6: So far, we’ve looked at the distribution of weight within species. Make a new plot to explore the distribution of hindfoot_length within each species.
# Add color to the data points on your boxplot according to the plot from which the sample was taken (plot_id).

class(surveys_complete$plot_id)
   # numeric, not ideal

surveys_complete$plot_id <- as.factor(surveys_complete$plot_id)
   # makes it a factor

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) +
  geom_jitter(alpha = 0.3, aes(colour = plot_id)) +
  geom_boxplot( alpha = 0)

# or

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) +
  geom_jitter(alpha = 0.3, aes(colour = as.factor(plot_id))) +
  geom_boxplot( alpha = 0)

# Challenge 7: In many types of data, it is important to consider the scale of the observations. 
# For example, it may be worth changing the scale of the axis to better distribute the observations in the space of the plot. 
# Changing the scale of the axes is done similarly to adding/modifying other components (i.e., by incrementally adding commands). 
# Make a scatter plot of species_id on the x-axis and weight on the y-axis with a log10 scale.

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_point() +
  scale_y_log10()

# Plotting timeseries data

# counts per year for genus

yearly_counts <- surveys_complete %>% 
  count(year, genus)

ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
  geom_line()
   # we have no data between years, and no genera, so...

ggplot(data = yearly_counts, mapping = aes(x = year, y = n, group = genus)) +
  geom_line()
   # this gives you one line for each genus

# Challenge 8: Modify the code for the yearly counts to colour by genus so we can
# clearly see the counts by genus.

ggplot(data = yearly_counts, mapping = aes(x = year, y = n, group = genus)) +
  geom_line(aes(colour = genus))


