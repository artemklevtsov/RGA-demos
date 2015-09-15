# File-Name:        daily-bar.R
# Date:             2015-09-14
# Author:           Artem Klevtsov
# Email:            a.a.klevtsov@gmail.com
# Purpose:          Create a daily users activity heatmap with the Google Analytics data
# Data Used:
# Packages Used:    RGA, stringi, ggplot2
# Output File:      daily-bar.png
# Data Output:
# Machine:          x86_64 GNU/Linux
# License:          CC BY 4.0

## Params
id <- 7783180 # Profile (View) ID
year <- 2014 # Year
locale <- "en_US" # Locale
metric <- "ga:pageviews" # GA metric

## Load pakcages
library(RGA)
library(ggplot2)

## Authorisation
authorize()

# Get data
ga_data <- get_ga(profile.id = id, start.date = start.date, end.date = end.date,
                  metrics = metric, dimensions = "ga:hour")

## Prepare data
# Convert hours to HH:MM format
ga_data$hour <- sprintf("%02d:00", ga_data$hour)

## Draw plot
p <- ggplot(ga_data, aes_string(x = "hour", y = gsub("ga:", "", metric))) +
    geom_bar(stat = "identity") +
    coord_flip() +
    labs(title = "Daily users activity")

if (interactive()) {
    # Print plot
    print(p)
} else {
    ## Save plot
    png(filename = "plots/daily-bar.png", res = 300, width = par("din")[1], height = par("din")[2], units = "in")
    print(p)
    dev.off()
}
